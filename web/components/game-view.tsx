"use client";

import { useState, useRef, useCallback, useEffect } from "react";
import { useGame } from "@/components/game-provider";
import { ScoreHeader } from "@/components/score-header";
import { MoveHistoryStrip } from "@/components/move-history-strip";
import { GameBoard } from "@/components/board/game-board";
import { CompactInputBar } from "@/components/score-input/compact-input-bar";
import { WinOverlay } from "@/components/win-overlay";
import { PlayerSetupModal } from "@/components/player-setup-modal";

export function GameView() {
  const {
    players,
    moves,
    activePlayerIndex,
    isGameOver,
    winnerIndex,
    selectPlayer,
    newGame,
    addScore,
    undo,
  } = useGame();

  const [showWinOverlay, setShowWinOverlay] = useState(true);
  const [showSetup, setShowSetup] = useState(false);
  const [confirmNewGame, setConfirmNewGame] = useState(false);

  // Track previous isGameOver to detect transitions
  const prevGameOver = useRef(isGameOver);
  if (isGameOver && !prevGameOver.current) {
    if (!showWinOverlay) setShowWinOverlay(true);
  }
  prevGameOver.current = isGameOver;

  // Keyboard shortcuts
  useEffect(() => {
    function handleKeyDown(e: KeyboardEvent) {
      // Don't capture when typing in inputs
      if (
        e.target instanceof HTMLInputElement ||
        e.target instanceof HTMLTextAreaElement
      )
        return;

      // Ctrl+Z / Cmd+Z = undo
      if ((e.ctrlKey || e.metaKey) && e.key === "z") {
        e.preventDefault();
        undo();
        return;
      }

      // Number keys 1-9 = score that many points
      if (!isGameOver && !showSetup && !confirmNewGame) {
        const num = parseInt(e.key);
        if (num >= 1 && num <= 9) {
          e.preventDefault();
          addScore(num);
          return;
        }
      }

      // Tab or left/right arrows = switch player
      if (e.key === "Tab" || e.key === "ArrowLeft" || e.key === "ArrowRight") {
        e.preventDefault();
        const count = players.length;
        if (e.key === "ArrowLeft" || (e.key === "Tab" && e.shiftKey)) {
          selectPlayer((activePlayerIndex - 1 + count) % count);
        } else {
          selectPlayer((activePlayerIndex + 1) % count);
        }
        return;
      }

      // Escape = close modals
      if (e.key === "Escape") {
        if (showSetup) setShowSetup(false);
        if (confirmNewGame) setConfirmNewGame(false);
        if (showWinOverlay && isGameOver) setShowWinOverlay(false);
      }
    }

    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [
    isGameOver,
    showSetup,
    confirmNewGame,
    showWinOverlay,
    players.length,
    activePlayerIndex,
    addScore,
    undo,
    selectPlayer,
  ]);

  // Swipe gesture handling
  const pointerStart = useRef<{ x: number; y: number } | null>(null);

  const onPointerDown = useCallback((e: React.PointerEvent) => {
    pointerStart.current = { x: e.clientX, y: e.clientY };
  }, []);

  const onPointerUp = useCallback(
    (e: React.PointerEvent) => {
      if (!pointerStart.current) return;
      const dx = e.clientX - pointerStart.current.x;
      const dy = e.clientY - pointerStart.current.y;
      pointerStart.current = null;

      if (Math.abs(dx) < 50 || Math.abs(dx) < Math.abs(dy)) return;

      const count = players.length;
      if (dx > 0) {
        selectPlayer((activePlayerIndex - 1 + count) % count);
      } else {
        selectPlayer((activePlayerIndex + 1) % count);
      }
    },
    [players.length, activePlayerIndex, selectPlayer]
  );

  // Click-to-place
  const handleHoleClick = useCallback(
    (hole: number) => {
      if (isGameOver) return;
      const activePlayer = players[activePlayerIndex];
      if (!activePlayer || hole <= activePlayer.frontPeg) return;
      const points = hole - activePlayer.frontPeg;
      addScore(points);
    },
    [players, activePlayerIndex, isGameOver, addScore]
  );

  const handleNewGame = () => {
    if (moves.length > 0 && !isGameOver) {
      setConfirmNewGame(true);
    } else {
      setShowSetup(true);
    }
  };

  const handleStartGame = (
    playerConfigs: { name: string; colorIndex: number }[]
  ) => {
    newGame(playerConfigs);
    setShowSetup(false);
    setShowWinOverlay(true);
  };

  return (
    <div
      className="h-dvh flex flex-col relative"
      style={{ backgroundColor: "var(--header-bg)" }}
    >
      <ScoreHeader
        players={players}
        activeIndex={activePlayerIndex}
        onSelectPlayer={selectPlayer}
      />

      <div className="h-[1px] bg-white/10" />

      <MoveHistoryStrip moves={moves} players={players} />

      <div
        className="flex-1 min-h-0 flex flex-col"
        onPointerDown={onPointerDown}
        onPointerUp={onPointerUp}
      >
        <GameBoard
          players={players}
          activePlayerIndex={activePlayerIndex}
          onHoleClick={handleHoleClick}
        />
      </div>

      <div className="h-[1px] bg-white/10" />

      <CompactInputBar
        onNewGame={handleNewGame}
        onShowResults={() => setShowWinOverlay(true)}
      />

      {/* Win overlay */}
      {isGameOver && showWinOverlay && winnerIndex !== null && (
        <WinOverlay
          winnerName={players[winnerIndex].name}
          winnerColorIndex={players[winnerIndex].colorIndex}
          players={players}
          moves={moves}
          onNewGame={() => {
            setShowWinOverlay(false);
            setShowSetup(true);
          }}
          onDismiss={() => setShowWinOverlay(false)}
        />
      )}

      {/* Player setup modal */}
      {showSetup && (
        <PlayerSetupModal
          onStart={handleStartGame}
          onCancel={() => setShowSetup(false)}
        />
      )}

      {/* Confirm new game dialog */}
      {confirmNewGame && (
        <>
          <div
            className="fixed inset-0 bg-black/40 z-40"
            onClick={() => setConfirmNewGame(false)}
          />
          <div
            className="fixed top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 z-50 p-6 rounded-2xl w-72 text-center"
            style={{ backgroundColor: "var(--section-bg)" }}
          >
            <p className="text-white font-semibold mb-1">New Game?</p>
            <p
              className="text-sm mb-4"
              style={{ color: "var(--text-secondary)" }}
            >
              Current game progress will be lost.
            </p>
            <div className="flex gap-3">
              <button
                className="flex-1 py-2.5 rounded-lg text-sm font-medium text-white"
                style={{ backgroundColor: "rgba(255,255,255,0.1)" }}
                onClick={() => setConfirmNewGame(false)}
              >
                Cancel
              </button>
              <button
                className="flex-1 py-2.5 rounded-lg text-sm font-medium text-white"
                style={{ backgroundColor: "var(--accent)" }}
                onClick={() => {
                  setConfirmNewGame(false);
                  setShowSetup(true);
                }}
              >
                New Game
              </button>
            </div>
          </div>
        </>
      )}
    </div>
  );
}
