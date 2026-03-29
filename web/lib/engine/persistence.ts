import { GameEngineState } from "./types";

const STORAGE_KEY = "cribforfish-game";

export function saveGame(state: GameEngineState): void {
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
  } catch {
    // localStorage may be full or unavailable
  }
}

export function loadGame(): GameEngineState | null {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return null;
    return JSON.parse(raw) as GameEngineState;
  } catch {
    return null;
  }
}
