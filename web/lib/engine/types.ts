export interface PlayerState {
  name: string;
  colorIndex: number; // 0=red, 1=blue, 2=green
  frontPeg: number; // current score position (0 = start)
  backPeg: number; // previous score position (0 = start)
}

export interface Move {
  playerIndex: number;
  points: number;
  previousFrontPeg: number;
  previousBackPeg: number;
}

export interface GameEngineState {
  players: PlayerState[];
  moves: Move[];
  activePlayerIndex: number;
  isGameOver: boolean;
  winnerIndex: number | null;
  playerCount: number;
  dealerIndex: number;
}

export const PLAYER_COLORS = [
  "rgb(230, 64, 51)", // red
  "rgb(77, 153, 255)", // blue
  "rgb(64, 217, 102)", // green
] as const;

export const PLAYER_COLOR_NAMES = ["Red", "Blue", "Green"] as const;

export function getPlayerColor(colorIndex: number): string {
  return PLAYER_COLORS[colorIndex] ?? PLAYER_COLORS[0];
}

export function hasWon(player: PlayerState): boolean {
  return player.frontPeg >= 121;
}

export function defaultPlayers(count: number): PlayerState[] {
  const names = ["Marlin", "Tuna", "Salmon"];
  return Array.from({ length: count }, (_, i) => ({
    name: names[i],
    colorIndex: i,
    frontPeg: 0,
    backPeg: 0,
  }));
}
