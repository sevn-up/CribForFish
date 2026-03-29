"use client";

import { Move, PlayerState, getPlayerColor } from "@/lib/engine/types";

interface MoveHistoryStripProps {
  moves: Move[];
  players: PlayerState[];
}

export function MoveHistoryStrip({ moves, players }: MoveHistoryStripProps) {
  const recentMoves = moves.slice(-20);

  return (
    <div
      className="h-6 overflow-x-auto overflow-y-hidden px-3 flex items-center"
      style={{ backgroundColor: "var(--header-bg)" }}
    >
      <div className="flex gap-1.5 min-w-0">
        {recentMoves.length === 0 ? (
          <span
            className="text-[10px] whitespace-nowrap"
            style={{ color: "var(--text-secondary)" }}
          >
            No moves yet
          </span>
        ) : (
          recentMoves.map((move, i) => {
            const color =
              move.playerIndex < players.length
                ? getPlayerColor(players[move.playerIndex].colorIndex)
                : "white";
            return (
              <div
                key={i}
                className="flex items-center gap-1 px-1.5 py-0.5 rounded-full shrink-0"
                style={{
                  backgroundColor: `color-mix(in srgb, ${color} 20%, transparent)`,
                }}
              >
                <div
                  className="w-2 h-2 rounded-full"
                  style={{ backgroundColor: color }}
                />
                <span className="text-[10px] font-medium text-white/80">
                  +{move.points}
                </span>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}
