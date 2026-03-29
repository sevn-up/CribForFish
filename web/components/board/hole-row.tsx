"use client";

import { PlayerState } from "@/lib/engine/types";
import { HoleDot, PegState } from "./hole-dot";

interface HoleRowProps {
  holeNumber: number;
  players: PlayerState[];
  size?: "sm" | "lg";
  activePlayerIndex?: number;
  onHoleClick?: (hole: number) => void;
}

function getPegState(player: PlayerState, hole: number): PegState {
  if (player.frontPeg === hole) return "front";
  if (player.backPeg === hole && player.backPeg !== 0) return "back";
  return "empty";
}

export function HoleRow({
  holeNumber,
  players,
  size = "sm",
  activePlayerIndex,
  onHoleClick,
}: HoleRowProps) {
  const gap = size === "lg" ? "gap-[5px]" : "gap-[3px]";

  return (
    <div className={`flex items-center justify-center ${gap}`}>
      {players.map((player, idx) => {
        const pegState = getPegState(player, holeNumber);
        const isActivePlayer = idx === activePlayerIndex;
        const canClick =
          isActivePlayer &&
          pegState === "empty" &&
          holeNumber > player.frontPeg &&
          holeNumber <= 121;

        return (
          <HoleDot
            key={idx}
            pegState={pegState}
            colorIndex={player.colorIndex}
            size={size}
            clickable={canClick}
            activeHighlight={canClick}
            onClick={canClick ? () => onHoleClick?.(holeNumber) : undefined}
          />
        );
      })}
    </div>
  );
}
