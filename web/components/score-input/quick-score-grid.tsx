"use client";

import { Star } from "lucide-react";

interface QuickScoreGridProps {
  activeColor: string;
  onScore: (points: number) => void;
  onClose: () => void;
}

export function QuickScoreGrid({
  activeColor,
  onScore,
  onClose,
}: QuickScoreGridProps) {
  const scores = Array.from({ length: 28 }, (_, i) => i + 1);

  return (
    <>
      {/* Backdrop */}
      <div
        className="fixed inset-0 bg-black/40 z-40"
        onClick={onClose}
      />
      {/* Sheet */}
      <div
        className="fixed bottom-0 left-0 right-0 z-50 rounded-t-2xl p-4 pb-8 animate-slide-up"
        style={{ backgroundColor: "var(--input-bg)" }}
      >
        <div className="flex justify-center mb-3">
          <div className="w-10 h-1 rounded-full bg-white/20" />
        </div>
        <h2
          className="text-lg font-semibold mb-3 text-center"
          style={{ color: "var(--text-primary)" }}
        >
          Score
        </h2>

        {/* Grid 1-28 */}
        <div className="grid grid-cols-5 gap-2">
          {scores.map((n) => (
            <button
              key={n}
              className="h-11 rounded-[10px] text-lg font-semibold active:scale-95 transition-transform"
              style={{
                backgroundColor: `color-mix(in srgb, ${activeColor} 15%, transparent)`,
                color: activeColor,
              }}
              onClick={() => {
                onScore(n);
                onClose();
              }}
            >
              {n}
            </button>
          ))}
        </div>

        {/* Perfect 29 */}
        <button
          className="w-full h-12 mt-3 rounded-[10px] flex items-center justify-center gap-2 text-lg font-semibold active:scale-95 transition-transform"
          style={{
            background:
              "linear-gradient(135deg, rgba(234,179,8,0.25), rgba(249,115,22,0.25))",
            color: "rgb(234,179,8)",
            border: "1.5px solid rgba(234,179,8,0.5)",
          }}
          onClick={() => {
            onScore(29);
            onClose();
          }}
        >
          <Star size={16} fill="currentColor" />
          Perfect 29
          <Star size={16} fill="currentColor" />
        </button>
      </div>
    </>
  );
}
