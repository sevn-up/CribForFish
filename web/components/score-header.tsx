"use client";

import { PlayerState, getPlayerColor } from "@/lib/engine/types";
import { ChevronUp } from "lucide-react";

interface ScoreHeaderProps {
  players: PlayerState[];
  activeIndex: number;
  onSelectPlayer: (index: number) => void;
}

export function ScoreHeader({
  players,
  activeIndex,
  onSelectPlayer,
}: ScoreHeaderProps) {
  return (
    <div className="flex" style={{ backgroundColor: "var(--header-bg)" }}>
      {players.map((player, idx) => {
        const color = getPlayerColor(player.colorIndex);
        const isActive = idx === activeIndex;

        return (
          <button
            key={idx}
            className="flex-1 flex flex-col items-center py-2 relative transition-all duration-200 group"
            style={{
              backgroundColor: isActive
                ? `color-mix(in srgb, ${color} 15%, transparent)`
                : "transparent",
            }}
            onClick={() => onSelectPlayer(idx)}
            title={
              isActive
                ? `${player.name} (active)`
                : `Click to switch to ${player.name} (or press Tab / ← →)`
            }
          >
            <span className="text-xs transition-all duration-200" style={{ color }}>
              {player.name}
            </span>
            <span
              className="text-2xl font-bold tabular-nums transition-all duration-200"
              style={{ color }}
            >
              {player.frontPeg}
            </span>
            {isActive ? (
              <ChevronUp size={10} style={{ color }} />
            ) : (
              <div className="h-[10px] flex items-center justify-center">
                <span
                  className="text-[8px] opacity-0 group-hover:opacity-60 transition-opacity duration-200 hidden md:block"
                  style={{ color }}
                >
                  click to switch
                </span>
              </div>
            )}
            {/* Active bottom border */}
            {isActive && (
              <div
                className="absolute bottom-0 left-0 right-0 h-0.5"
                style={{ backgroundColor: color }}
              />
            )}
            {/* Hover glow for inactive players (desktop only) */}
            {!isActive && (
              <div
                className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-200 pointer-events-none hidden md:block"
                style={{
                  background: `radial-gradient(ellipse at center bottom, ${color}15 0%, transparent 70%)`,
                }}
              />
            )}
          </button>
        );
      })}
    </div>
  );
}
