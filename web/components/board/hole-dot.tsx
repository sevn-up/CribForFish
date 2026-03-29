"use client";

import { getPlayerColor } from "@/lib/engine/types";

export type PegState = "front" | "back" | "empty";

interface HoleDotProps {
  pegState: PegState;
  colorIndex: number;
  size?: "sm" | "lg";
  clickable?: boolean;
  activeHighlight?: boolean;
  onClick?: () => void;
}

// Fixed cell sizes — all dots render inside same-sized containers
// This prevents layout shifts when peg states change
const CELL_SIZES = { sm: 10, lg: 16 };
const DOT_SIZES = {
  sm: { front: 8, back: 6, empty: 5 },
  lg: { front: 12, back: 9, empty: 7 },
};

export function HoleDot({
  pegState,
  colorIndex,
  size = "sm",
  clickable,
  activeHighlight,
  onClick,
}: HoleDotProps) {
  const color = getPlayerColor(colorIndex);
  const cell = CELL_SIZES[size];
  const dot = DOT_SIZES[size];

  const isClickTarget = clickable && pegState === "empty";

  // All dots sit inside a fixed-size cell to prevent layout shifts
  return (
    <div
      className={`flex items-center justify-center ${isClickTarget ? "cursor-pointer group" : ""}`}
      style={{ width: cell, height: cell }}
      onClick={isClickTarget ? onClick : undefined}
    >
      {pegState === "front" ? (
        <div
          className="rounded-full transition-all duration-200 ease-in-out"
          style={{
            width: dot.front,
            height: dot.front,
            backgroundColor: color,
            boxShadow: `0 0 ${size === "lg" ? 6 : 4}px ${color}80`,
            border: `${size === "lg" ? 1.5 : 1}px solid ${color}80`,
          }}
        />
      ) : pegState === "back" ? (
        <div
          className="rounded-full transition-all duration-200 ease-in-out"
          style={{
            width: dot.back,
            height: dot.back,
            backgroundColor: `color-mix(in srgb, ${color} 60%, transparent)`,
            border: `${size === "lg" ? 1 : 0.5}px solid ${color}80`,
          }}
        />
      ) : (
        <div
          className={`rounded-full transition-all duration-200 ease-in-out ${isClickTarget ? "group-hover:scale-[1.6]" : ""}`}
          style={{
            width: dot.empty,
            height: dot.empty,
            backgroundColor: activeHighlight
              ? `color-mix(in srgb, ${color} 35%, transparent)`
              : "var(--empty-hole)",
            border: activeHighlight
              ? `1.5px solid ${color}60`
              : "0.5px solid rgba(255,255,255,0.15)",
            boxShadow: activeHighlight ? `0 0 4px ${color}30` : "none",
          }}
        />
      )}
    </div>
  );
}
