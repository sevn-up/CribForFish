"use client";

import { useState } from "react";
import { PlayerState, Move, getPlayerColor } from "@/lib/engine/types";
import { Trophy, RotateCcw, BarChart3 } from "lucide-react";

interface WinOverlayProps {
  winnerName: string;
  winnerColorIndex: number;
  players: PlayerState[];
  moves: Move[];
  onNewGame: () => void;
  onDismiss: () => void;
}

export function WinOverlay({
  winnerName,
  winnerColorIndex,
  players,
  moves,
  onNewGame,
  onDismiss,
}: WinOverlayProps) {
  const [showStats, setShowStats] = useState(false);
  const winnerColor = getPlayerColor(winnerColorIndex);
  const winnerScore =
    players.find((p) => p.name === winnerName)?.frontPeg ?? 121;

  // Skunk logic
  const losers = players.filter((p) => p.name !== winnerName);
  const worstScore = Math.min(...losers.map((p) => p.frontPeg));
  const skunkText =
    worstScore < 60
      ? "\u{1F480} Double Skunked!"
      : worstScore < 90
        ? "\u{1F9A8} Skunked!"
        : null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Backdrop */}
      <div
        className="absolute inset-0 bg-black/50"
        onClick={onDismiss}
      />
      {/* Card */}
      <div
        className="relative z-10 flex flex-col items-center p-10 rounded-3xl max-w-sm w-[calc(100%-32px)] animate-fade-in"
        style={{ backgroundColor: "rgba(89,61,36,0.95)" }}
      >
        <Trophy size={60} style={{ color: winnerColor }} />

        <p
          className="text-base mt-4"
          style={{ color: "var(--text-secondary)" }}
        >
          Game Over!
        </p>

        <p className="text-3xl font-bold text-white mt-1">
          {winnerName} Wins!
        </p>

        <p className="text-base text-white/80 mt-1">{winnerScore} points</p>

        {skunkText && (
          <p className="text-base font-semibold text-orange-400 mt-2">
            {skunkText}
          </p>
        )}

        {/* Stats toggle */}
        <button
          className="flex items-center gap-1.5 mt-4 text-sm"
          style={{ color: "var(--accent)" }}
          onClick={() => setShowStats(!showStats)}
        >
          <BarChart3 size={14} />
          Game Stats
        </button>

        {showStats && (
          <div className="w-full mt-3 rounded-xl bg-white/5 py-2">
            {/* Header row */}
            <div className="flex px-3 pb-1.5 text-[10px]" style={{ color: "var(--text-secondary)" }}>
              <span className="flex-1">Player</span>
              <span className="w-11 text-center">Score</span>
              <span className="w-12 text-center">Hands</span>
              <span className="w-10 text-center">Best</span>
              <span className="w-10 text-center">Avg</span>
            </div>
            {players.map((player, idx) => {
              const playerMoves = moves.filter(
                (m) => m.playerIndex === idx
              );
              const best =
                playerMoves.length > 0
                  ? Math.max(...playerMoves.map((m) => m.points))
                  : 0;
              const avg =
                playerMoves.length > 0
                  ? playerMoves.reduce((s, m) => s + m.points, 0) /
                    playerMoves.length
                  : 0;
              const isWinner = player.name === winnerName;
              const color = getPlayerColor(player.colorIndex);

              return (
                <div
                  key={idx}
                  className="flex items-center px-3 py-1.5 text-xs text-white rounded-md mx-1"
                  style={{
                    backgroundColor: isWinner
                      ? `color-mix(in srgb, ${color} 15%, transparent)`
                      : "transparent",
                  }}
                >
                  <span className="flex-1 flex items-center gap-1 min-w-0">
                    <span
                      className="w-2 h-2 rounded-full shrink-0"
                      style={{ backgroundColor: color }}
                    />
                    <span className="truncate">{player.name}</span>
                  </span>
                  <span className="w-11 text-center">{player.frontPeg}</span>
                  <span className="w-12 text-center">{playerMoves.length}</span>
                  <span className="w-10 text-center">{best}</span>
                  <span className="w-10 text-center">{avg.toFixed(1)}</span>
                </div>
              );
            })}
          </div>
        )}

        {/* Play Again */}
        <button
          className="flex items-center gap-2 mt-5 px-8 py-3.5 rounded-full text-base font-semibold text-white active:scale-95 transition-transform"
          style={{ backgroundColor: winnerColor }}
          onClick={onNewGame}
        >
          <RotateCcw size={18} />
          Play Again
        </button>

        {/* View Board */}
        <button
          className="mt-3 text-sm"
          style={{ color: "var(--text-secondary)" }}
          onClick={onDismiss}
        >
          View Board
        </button>
      </div>
    </div>
  );
}
