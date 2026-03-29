"use client";

import { useState } from "react";
import { PlayerState, getPlayerColor } from "@/lib/engine/types";
import { HOLES_PER_ROW } from "@/lib/engine/board-layout";
import { HoleRow } from "./hole-row";
import { HoleDot, PegState } from "./hole-dot";
import { Flag, Trophy } from "lucide-react";

interface GameBoardProps {
  players: PlayerState[];
  activePlayerIndex?: number;
  onHoleClick?: (hole: number) => void;
}

/* ── Shared sub-components ─────────────────────────────────── */

function SkunkMarker({
  label,
  horizontal,
}: {
  label: string;
  horizontal?: boolean;
}) {
  if (horizontal) {
    return (
      <div className="flex flex-col items-center gap-0.5 px-[2px]">
        <div className="w-[1.5px] flex-1 bg-red-500/35" />
        <span className="text-[7px] font-bold text-red-500/50 [writing-mode:vertical-lr] rotate-180">
          {label}
        </span>
        <div className="w-[1.5px] flex-1 bg-red-500/35" />
      </div>
    );
  }
  return (
    <div className="flex items-center gap-1 py-[1px]">
      <div className="flex-1 h-[1px] bg-red-500/35" />
      <span className="text-[6px] font-bold text-red-500/50">{label}</span>
      <div className="flex-1 h-[1px] bg-red-500/35" />
    </div>
  );
}

function StartArea({
  players,
  horizontal,
  size,
}: {
  players: PlayerState[];
  horizontal?: boolean;
  size?: "sm" | "lg";
}) {
  const dotSize = size === "lg" ? "w-3 h-3" : "w-2.5 h-2.5";
  return (
    <div
      className={`flex items-center justify-center gap-2 px-3 rounded-full ${horizontal ? "py-3 flex-col" : "py-1 mx-auto"}`}
      style={{ backgroundColor: "var(--section-bg)" }}
    >
      <Flag
        size={horizontal ? 12 : 8}
        style={{ color: "var(--text-secondary)" }}
      />
      <span
        className={`font-semibold ${horizontal ? "text-xs" : "text-[10px]"}`}
        style={{ color: "var(--text-secondary)" }}
      >
        START
      </span>
      <div className={`flex gap-1.5 ${horizontal ? "flex-col" : ""}`}>
        {players.map((player, idx) => (
          <div
            key={idx}
            className={`${dotSize} rounded-full`}
            style={{
              backgroundColor:
                player.frontPeg === 0
                  ? getPlayerColor(player.colorIndex)
                  : "rgba(255,255,255,0.15)",
            }}
          />
        ))}
      </div>
    </div>
  );
}

function FinishArea({
  players,
  horizontal,
  size,
}: {
  players: PlayerState[];
  horizontal?: boolean;
  size?: "sm" | "lg";
}) {
  const dotSize = size === "lg" ? "w-3 h-3" : "w-2.5 h-2.5";
  return (
    <div
      className={`flex items-center justify-center gap-2 px-3 rounded-full shadow-sm ${horizontal ? "py-3 flex-col" : "py-1.5 mx-auto"}`}
      style={{
        backgroundColor: "var(--section-bg)",
        boxShadow: "0 2px 4px rgba(0,0,0,0.2)",
      }}
    >
      <Trophy
        size={horizontal ? 18 : 14}
        className="text-yellow-400"
      />
      <span
        className={`font-bold ${horizontal ? "text-xs" : "text-[10px]"}`}
        style={{ color: "var(--text-primary)" }}
      >
        FINISH
      </span>
      <div
        className={`flex gap-1.5 items-center ${horizontal ? "flex-col" : ""}`}
      >
        {players.map((player, idx) => (
          <div
            key={idx}
            className={`${dotSize} rounded-full`}
            style={{
              backgroundColor:
                player.frontPeg >= 121
                  ? getPlayerColor(player.colorIndex)
                  : "var(--empty-hole)",
              border: `0.5px solid ${getPlayerColor(player.colorIndex)}4d`,
            }}
          />
        ))}
      </div>
      <span
        className={`${horizontal ? "text-[10px]" : "text-[8px]"}`}
        style={{ color: "var(--text-secondary)" }}
      >
        121
      </span>
    </div>
  );
}

/* ── Vertical Street (mobile) ──────────────────────────────── */

function VerticalStreet({
  startHole,
  players,
  labelsOnLeft,
  streetLabel,
  activePlayerIndex,
  onHoleClick,
}: {
  startHole: number;
  players: PlayerState[];
  labelsOnLeft: boolean;
  streetLabel: string;
  activePlayerIndex?: number;
  onHoleClick?: (hole: number) => void;
}) {
  const groups = Array.from({ length: 12 }, (_, g) => g);

  return (
    <div className="flex-1 flex flex-col">
      <div className="flex items-center justify-center gap-1 py-0.5">
        <span
          className="text-[9px] font-semibold"
          style={{ color: "var(--text-secondary)" }}
        >
          {streetLabel}
        </span>
      </div>
      <div className="flex-1 flex flex-col justify-between">
        {groups.map((g) => {
          const groupStartHole = startHole + g * 5;
          const lastHoleInGroup = groupStartHole + 4;
          const showDoubleSkunk = lastHoleInGroup === 60;
          const showSkunk = lastHoleInGroup === 90;

          return (
            <div key={g}>
              <div className="flex items-center gap-0">
                {labelsOnLeft && (
                  <span
                    className="w-[18px] text-[8px] font-mono text-right pr-1"
                    style={{ color: "var(--text-secondary)", opacity: 0.5 }}
                  >
                    {groupStartHole}
                  </span>
                )}
                <div className="flex-1 flex flex-col gap-[2px] py-[2px]">
                  {Array.from({ length: HOLES_PER_ROW }, (_, pos) => (
                    <HoleRow
                      key={pos}
                      holeNumber={groupStartHole + pos}
                      players={players}
                      activePlayerIndex={activePlayerIndex}
                      onHoleClick={onHoleClick}
                    />
                  ))}
                </div>
                {!labelsOnLeft && (
                  <span
                    className="w-[18px] text-[8px] font-mono text-left pl-1"
                    style={{ color: "var(--text-secondary)", opacity: 0.5 }}
                  >
                    {groupStartHole}
                  </span>
                )}
              </div>
              {g < 11 && (
                <>
                  {showDoubleSkunk ? (
                    <SkunkMarker label="S×2" />
                  ) : showSkunk ? (
                    <SkunkMarker label="S" />
                  ) : (
                    <div
                      className="h-[0.5px] mx-1"
                      style={{
                        backgroundColor: "var(--accent)",
                        opacity: 0.08,
                      }}
                    />
                  )}
                </>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

/* ── Horizontal Track Group (desktop) ──────────────────────── */
/* Renders one group of 5 holes as a grid:
   rows = player tracks, columns = 5 consecutive holes.
   This mimics a real cribbage board where tracks run horizontally. */

function getPegState(
  player: PlayerState,
  hole: number
): PegState {
  if (player.frontPeg === hole) return "front";
  if (player.backPeg === hole && player.backPeg !== 0) return "back";
  return "empty";
}

function TrackGroup({
  startHole,
  players,
  activePlayerIndex,
  onHoleClick,
}: {
  startHole: number;
  players: PlayerState[];
  activePlayerIndex?: number;
  onHoleClick?: (hole: number) => void;
}) {
  const holes = Array.from({ length: 5 }, (_, i) => startHole + i);

  return (
    <div className="flex flex-col gap-0">
      {players.map((player, pIdx) => {
        const isActive = pIdx === activePlayerIndex;
        return (
          <div key={pIdx} className="flex justify-between">
            {holes.map((hole) => {
              const pegState = getPegState(player, hole);
              const canClick =
                isActive &&
                pegState === "empty" &&
                hole > player.frontPeg &&
                hole <= 121;
              return (
                <HoleDot
                  key={hole}
                  pegState={pegState}
                  colorIndex={player.colorIndex}
                  size="lg"
                  clickable={canClick}
                  activeHighlight={canClick}
                  onClick={
                    canClick ? () => onHoleClick?.(hole) : undefined
                  }
                />
              );
            })}
          </div>
        );
      })}
    </div>
  );
}

function HorizontalStreet({
  startHole,
  players,
  labelsOnTop,
  streetLabel,
  activePlayerIndex,
  onHoleClick,
}: {
  startHole: number;
  players: PlayerState[];
  labelsOnTop: boolean;
  streetLabel: string;
  activePlayerIndex?: number;
  onHoleClick?: (hole: number) => void;
}) {
  const groups = Array.from({ length: 12 }, (_, g) => g);

  return (
    <div className="flex flex-col">
      <div className="flex items-center justify-center gap-1 py-1">
        <span
          className="text-[10px] font-semibold"
          style={{ color: "var(--text-secondary)" }}
        >
          {streetLabel}
        </span>
      </div>
      <div className="flex flex-row items-center gap-0">
        {groups.map((g) => {
          const groupStartHole = startHole + g * 5;
          const lastHoleInGroup = groupStartHole + 4;
          const showDoubleSkunk = lastHoleInGroup === 60;
          const showSkunk = lastHoleInGroup === 90;

          return (
            <div key={g} className="flex-1 flex items-center min-w-0">
              <div className="flex-1 flex flex-col items-center min-w-0">
                {labelsOnTop && (
                  <span
                    className="text-[8px] font-mono pb-1"
                    style={{ color: "var(--text-secondary)", opacity: 0.5 }}
                  >
                    {groupStartHole}
                  </span>
                )}
                <TrackGroup
                  startHole={groupStartHole}
                  players={players}
                  activePlayerIndex={activePlayerIndex}
                  onHoleClick={onHoleClick}
                />
                {!labelsOnTop && (
                  <span
                    className="text-[8px] font-mono pt-1"
                    style={{ color: "var(--text-secondary)", opacity: 0.5 }}
                  >
                    {groupStartHole}
                  </span>
                )}
              </div>
              {g < 11 && (
                <div className="flex items-stretch self-stretch">
                  {showDoubleSkunk ? (
                    <SkunkMarker label="S×2" horizontal />
                  ) : showSkunk ? (
                    <SkunkMarker label="S" horizontal />
                  ) : (
                    <div
                      className="w-[0.5px] self-stretch my-1"
                      style={{
                        backgroundColor: "var(--accent)",
                        opacity: 0.08,
                      }}
                    />
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
}

/* ── Board exports ─────────────────────────────────────────── */

export function GameBoard({
  players,
  activePlayerIndex,
  onHoleClick,
}: GameBoardProps) {
  return (
    <>
      {/* Mobile: vertical layout */}
      <div
        className="flex-1 flex flex-col overflow-y-auto px-2 py-2 md:hidden"
        style={{
          background:
            "linear-gradient(to bottom, var(--board-gradient-start), var(--board-gradient-end))",
          touchAction: "manipulation",
        }}
      >
        <StartArea players={players} />
        <div className="flex-1 flex gap-0 mt-1 mb-1">
          <VerticalStreet
            startHole={1}
            players={players}
            labelsOnLeft={true}
            streetLabel="1st Street"
            activePlayerIndex={activePlayerIndex}
            onHoleClick={onHoleClick}
          />
          <div
            className="w-[1.5px] self-stretch"
            style={{ backgroundColor: "var(--accent)", opacity: 0.25 }}
          />
          <VerticalStreet
            startHole={61}
            players={players}
            labelsOnLeft={false}
            streetLabel="2nd Street"
            activePlayerIndex={activePlayerIndex}
            onHoleClick={onHoleClick}
          />
        </div>
        <FinishArea players={players} />
      </div>

      {/* Desktop: horizontal track layout */}
      <div
        className="hidden md:flex flex-1 flex-col overflow-x-auto px-4 py-3 justify-center"
        style={{
          background:
            "linear-gradient(to right, var(--board-gradient-start), var(--board-gradient-end))",
        }}
      >
        <div className="flex flex-row items-center gap-4 min-w-0">
          <StartArea players={players} horizontal size="lg" />

          <div className="flex-1 flex flex-col gap-0 min-w-0">
            <HorizontalStreet
              startHole={1}
              players={players}
              labelsOnTop={true}
              streetLabel="1st Street"
              activePlayerIndex={activePlayerIndex}
              onHoleClick={onHoleClick}
            />
            <div
              className="h-[1.5px] mx-2 my-1.5"
              style={{ backgroundColor: "var(--accent)", opacity: 0.25 }}
            />
            <HorizontalStreet
              startHole={61}
              players={players}
              labelsOnTop={false}
              streetLabel="2nd Street"
              activePlayerIndex={activePlayerIndex}
              onHoleClick={onHoleClick}
            />
          </div>

          <FinishArea players={players} horizontal size="lg" />
        </div>
      </div>
    </>
  );
}
