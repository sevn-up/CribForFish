"use client";

import React, {
  createContext,
  useContext,
  useReducer,
  useEffect,
  useCallback,
  useRef,
} from "react";
import {
  GameEngineState,
  PlayerState,
  Move,
} from "@/lib/engine/types";
import {
  gameReducer,
  createInitialState,
  GameAction,
} from "@/lib/engine/game-reducer";
import { saveGame, loadGame } from "@/lib/engine/persistence";

interface GameContextValue {
  players: PlayerState[];
  moves: Move[];
  activePlayerIndex: number;
  isGameOver: boolean;
  winnerIndex: number | null;
  playerCount: number;
  leadingHole: number;
  addScore: (points: number, playerIndex?: number) => void;
  undo: () => void;
  selectPlayer: (index: number) => void;
  newGame: (players: { name: string; colorIndex: number }[]) => void;
}

const GameContext = createContext<GameContextValue | null>(null);

export function useGame(): GameContextValue {
  const ctx = useContext(GameContext);
  if (!ctx) throw new Error("useGame must be used within GameProvider");
  return ctx;
}

export function GameProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(gameReducer, createInitialState(3));
  const loaded = useRef(false);

  // Load from localStorage on mount
  useEffect(() => {
    const saved = loadGame();
    if (saved) {
      dispatch({ type: "LOAD_STATE", state: saved });
    }
    loaded.current = true;
  }, []);

  // Save to localStorage on every state change (after initial load)
  useEffect(() => {
    if (loaded.current) {
      saveGame(state);
    }
  }, [state]);

  const addScore = useCallback(
    (points: number, playerIndex?: number) => {
      const action: GameAction =
        playerIndex !== undefined
          ? { type: "ADD_SCORE", points, playerIndex }
          : { type: "ADD_SCORE", points };
      dispatch(action);
    },
    []
  );

  const undo = useCallback(() => dispatch({ type: "UNDO" }), []);

  const selectPlayer = useCallback(
    (index: number) => dispatch({ type: "SELECT_PLAYER", index }),
    []
  );

  const newGame = useCallback(
    (players: { name: string; colorIndex: number }[]) =>
      dispatch({ type: "NEW_GAME", players }),
    []
  );

  const leadingHole = Math.max(...state.players.map((p) => p.frontPeg), 0);

  const value: GameContextValue = {
    players: state.players,
    moves: state.moves,
    activePlayerIndex: state.activePlayerIndex,
    isGameOver: state.isGameOver,
    winnerIndex: state.winnerIndex,
    playerCount: state.playerCount,
    leadingHole,
    addScore,
    undo,
    selectPlayer,
    newGame,
  };

  return <GameContext.Provider value={value}>{children}</GameContext.Provider>;
}
