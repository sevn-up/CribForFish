"use client";

import { useState } from "react";
import { getPlayerColor } from "@/lib/engine/types";
import { useGame } from "@/components/game-provider";
import { QuickScoreGrid } from "./quick-score-grid";
import { Undo2, RotateCcw, Plus, Trophy, Star } from "lucide-react";

interface CompactInputBarProps {
  onNewGame: () => void;
  onShowResults: () => void;
}

export function CompactInputBar({
  onNewGame,
  onShowResults,
}: CompactInputBarProps) {
  const { players, moves, activePlayerIndex, isGameOver, addScore, undo } =
    useGame();
  const [showScoreGrid, setShowScoreGrid] = useState(false);

  const activeColor = getPlayerColor(
    players[activePlayerIndex]?.colorIndex ?? 0
  );

  if (isGameOver) {
    return (
      <div
        className="h-14 flex items-center justify-center gap-4 px-4"
        style={{ backgroundColor: "var(--header-bg)" }}
      >
        <button
          className="flex items-center gap-2 px-4 py-2 rounded-full transition-all duration-200 hover:brightness-125"
          style={{
            backgroundColor: `color-mix(in srgb, var(--accent) 15%, transparent)`,
            color: "var(--accent)",
          }}
          onClick={onShowResults}
        >
          <Trophy size={16} />
          <span className="text-sm font-medium">Results</span>
        </button>
        <button
          className="flex items-center gap-2 px-4 py-2 rounded-full text-white transition-all duration-200 hover:brightness-125 hover:scale-105"
          style={{ backgroundColor: "var(--accent)" }}
          onClick={onNewGame}
        >
          <RotateCcw size={16} />
          <span className="text-sm font-medium">New Game</span>
        </button>
      </div>
    );
  }

  return (
    <>
      {/* Mobile: compact 1-6 + modal */}
      <div
        className="h-14 flex items-center gap-2 px-3 md:hidden"
        style={{ backgroundColor: "var(--header-bg)" }}
      >
        <button
          className="w-9 h-9 flex items-center justify-center rounded-lg disabled:opacity-30"
          style={{ color: "var(--text-primary)" }}
          disabled={moves.length === 0}
          onClick={undo}
        >
          <Undo2 size={18} />
        </button>

        <div className="flex-1 flex gap-1.5">
          {[1, 2, 3, 4, 5, 6].map((n) => (
            <button
              key={n}
              className="flex-1 h-9 rounded-lg text-sm font-semibold active:scale-95 transition-transform"
              style={{
                backgroundColor: `color-mix(in srgb, ${activeColor} 20%, transparent)`,
                color: activeColor,
              }}
              onClick={() => addScore(n)}
            >
              {n}
            </button>
          ))}
          <button
            className="w-9 h-9 flex items-center justify-center rounded-lg active:scale-95 transition-transform"
            style={{
              backgroundColor: `color-mix(in srgb, var(--accent) 20%, transparent)`,
              color: "var(--accent)",
            }}
            onClick={() => setShowScoreGrid(true)}
          >
            <Plus size={18} />
          </button>
        </div>

        <button
          className="w-9 h-9 flex items-center justify-center rounded-lg"
          style={{ color: "var(--accent)" }}
          onClick={onNewGame}
        >
          <RotateCcw size={18} />
        </button>
      </div>

      {/* Desktop: full 1-29 grid inline with hover effects + key hints */}
      <div
        className="hidden md:flex items-center gap-3 px-4 py-2"
        style={{ backgroundColor: "var(--header-bg)" }}
      >
        <button
          className="h-10 px-3 flex items-center gap-1.5 rounded-lg disabled:opacity-30 shrink-0 transition-all duration-150 hover:bg-white/10"
          style={{ color: "var(--text-primary)" }}
          disabled={moves.length === 0}
          onClick={undo}
          title="Undo (Ctrl+Z)"
        >
          <Undo2 size={18} />
          <span className="text-xs font-medium">Undo</span>
        </button>

        <div className="flex-1 flex flex-wrap gap-1.5 justify-center">
          {Array.from({ length: 28 }, (_, i) => i + 1).map((n) => (
            <button
              key={n}
              className="relative w-10 h-9 rounded-lg text-sm font-semibold transition-all duration-150 hover:scale-110 hover:brightness-125 active:scale-95 group/btn"
              style={{
                backgroundColor: `color-mix(in srgb, ${activeColor} 20%, transparent)`,
                color: activeColor,
              }}
              onClick={() => addScore(n)}
              title={n <= 9 ? `Score ${n} (press ${n} key)` : `Score ${n}`}
            >
              {n}
              {/* Keyboard shortcut hint for 1-9 */}
              {n <= 9 && (
                <span className="absolute -top-1 -right-1 w-3.5 h-3.5 rounded text-[8px] font-mono leading-none flex items-center justify-center bg-white/10 text-white/40 opacity-0 group-hover/btn:opacity-100 transition-opacity duration-150 pointer-events-none">
                  {n}
                </span>
              )}
            </button>
          ))}
          {/* Perfect 29 */}
          <button
            className="h-9 px-3 rounded-lg text-sm font-semibold transition-all duration-150 hover:scale-105 hover:brightness-125 active:scale-95 flex items-center gap-1"
            style={{
              background:
                "linear-gradient(135deg, rgba(234,179,8,0.25), rgba(249,115,22,0.25))",
              color: "rgb(234,179,8)",
              border: "1.5px solid rgba(234,179,8,0.5)",
            }}
            onClick={() => addScore(29)}
            title="Perfect 29!"
          >
            <Star size={12} fill="currentColor" />
            29
            <Star size={12} fill="currentColor" />
          </button>
        </div>

        <button
          className="w-10 h-10 flex items-center justify-center rounded-lg shrink-0 transition-all duration-150 hover:bg-white/10"
          style={{ color: "var(--accent)" }}
          onClick={onNewGame}
          title="New Game"
        >
          <RotateCcw size={20} />
        </button>
      </div>

      {showScoreGrid && (
        <QuickScoreGrid
          activeColor={activeColor}
          onScore={(pts) => addScore(pts)}
          onClose={() => setShowScoreGrid(false)}
        />
      )}
    </>
  );
}
