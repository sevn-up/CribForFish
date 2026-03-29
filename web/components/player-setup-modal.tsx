"use client";

import { useState } from "react";
import { PLAYER_COLORS } from "@/lib/engine/types";

interface PlayerSetupModalProps {
  onStart: (players: { name: string; colorIndex: number }[]) => void;
  onCancel: () => void;
}

const DEFAULTS = [
  { name: "Marlin", colorIndex: 0 },
  { name: "Tuna", colorIndex: 1 },
  { name: "Salmon", colorIndex: 2 },
];

export function PlayerSetupModal({ onStart, onCancel }: PlayerSetupModalProps) {
  const [playerCount, setPlayerCount] = useState(2);
  const [names, setNames] = useState(DEFAULTS.map((d) => d.name));
  const [colors, setColors] = useState(DEFAULTS.map((d) => d.colorIndex));

  const handleStart = () => {
    const players = Array.from({ length: playerCount }, (_, i) => ({
      name: names[i].trim() || `Player ${i + 1}`,
      colorIndex: colors[i],
    }));
    onStart(players);
  };

  return (
    <>
      {/* Backdrop */}
      <div className="fixed inset-0 bg-black/40 z-40" onClick={onCancel} />
      {/* Sheet */}
      <div
        className="fixed bottom-0 left-0 right-0 z-50 rounded-t-2xl p-6 animate-slide-up"
        style={{ backgroundColor: "var(--input-bg)" }}
      >
        <h2
          className="text-lg font-semibold text-center mb-5"
          style={{ color: "white" }}
        >
          New Game
        </h2>

        {/* Player count picker */}
        <div className="flex rounded-lg overflow-hidden mb-5">
          {[2, 3].map((count) => (
            <button
              key={count}
              className="flex-1 py-2 text-sm font-medium transition-colors"
              style={{
                backgroundColor:
                  playerCount === count
                    ? "var(--accent)"
                    : "rgba(255,255,255,0.1)",
                color: playerCount === count ? "white" : "var(--text-secondary)",
              }}
              onClick={() => setPlayerCount(count)}
            >
              {count} Players
            </button>
          ))}
        </div>

        {/* Player configs */}
        <div className="flex flex-col gap-3 mb-5">
          {Array.from({ length: playerCount }, (_, idx) => (
            <div key={idx} className="flex items-center gap-3">
              <input
                type="text"
                value={names[idx]}
                onChange={(e) => {
                  const next = [...names];
                  next[idx] = e.target.value;
                  setNames(next);
                }}
                placeholder={`Player ${idx + 1}`}
                className="flex-1 bg-white/10 text-white px-3 py-2 rounded-lg text-sm outline-none placeholder:text-white/40"
              />
              <div className="flex gap-1.5">
                {PLAYER_COLORS.map((color, ci) => (
                  <button
                    key={ci}
                    className="w-7 h-7 rounded-full transition-all"
                    style={{
                      backgroundColor: color,
                      boxShadow:
                        colors[idx] === ci
                          ? "0 0 0 2px white"
                          : "none",
                    }}
                    onClick={() => {
                      const next = [...colors];
                      next[idx] = ci;
                      setColors(next);
                    }}
                  />
                ))}
              </div>
            </div>
          ))}
        </div>

        {/* Buttons */}
        <div className="flex gap-4">
          <button
            className="flex-1 py-3 rounded-[10px] text-sm font-semibold text-white"
            style={{ backgroundColor: "rgba(255,255,255,0.1)" }}
            onClick={onCancel}
          >
            Cancel
          </button>
          <button
            className="flex-1 py-3 rounded-[10px] text-sm font-semibold text-white"
            style={{ backgroundColor: "var(--accent)" }}
            onClick={handleStart}
          >
            Start
          </button>
        </div>
      </div>
    </>
  );
}
