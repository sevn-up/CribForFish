import { GameEngineState, Move, PlayerState, defaultPlayers } from "./types";

export type GameAction =
  | { type: "ADD_SCORE"; points: number; playerIndex?: number }
  | { type: "UNDO" }
  | { type: "SELECT_PLAYER"; index: number }
  | {
      type: "NEW_GAME";
      players: { name: string; colorIndex: number }[];
    }
  | { type: "LOAD_STATE"; state: GameEngineState };

export function createInitialState(playerCount: number = 3): GameEngineState {
  return {
    players: defaultPlayers(playerCount),
    moves: [],
    activePlayerIndex: 0,
    isGameOver: false,
    winnerIndex: null,
    playerCount,
    dealerIndex: 0,
  };
}

export function gameReducer(
  state: GameEngineState,
  action: GameAction
): GameEngineState {
  switch (action.type) {
    case "ADD_SCORE": {
      if (state.isGameOver) return state;
      const idx = action.playerIndex ?? state.activePlayerIndex;
      if (idx < 0 || idx >= state.players.length) return state;

      const player = state.players[idx];
      const move: Move = {
        playerIndex: idx,
        points: action.points,
        previousFrontPeg: player.frontPeg,
        previousBackPeg: player.backPeg,
      };

      const newFrontPeg = Math.min(player.frontPeg + action.points, 121);
      const newPlayers = state.players.map((p, i) =>
        i === idx
          ? { ...p, backPeg: p.frontPeg, frontPeg: newFrontPeg }
          : p
      );

      const won = newFrontPeg >= 121;

      return {
        ...state,
        players: newPlayers,
        moves: [...state.moves, move],
        isGameOver: won,
        winnerIndex: won ? idx : state.winnerIndex,
      };
    }

    case "UNDO": {
      if (state.moves.length === 0) return state;
      const lastMove = state.moves[state.moves.length - 1];
      const idx = lastMove.playerIndex;

      const newPlayers = state.players.map((p, i) =>
        i === idx
          ? {
              ...p,
              frontPeg: lastMove.previousFrontPeg,
              backPeg: lastMove.previousBackPeg,
            }
          : p
      );

      return {
        ...state,
        players: newPlayers,
        moves: state.moves.slice(0, -1),
        isGameOver: false,
        winnerIndex: null,
        activePlayerIndex: idx,
      };
    }

    case "SELECT_PLAYER": {
      if (action.index < 0 || action.index >= state.players.length)
        return state;
      return { ...state, activePlayerIndex: action.index };
    }

    case "NEW_GAME": {
      const players: PlayerState[] = action.players.map((p) => ({
        name: p.name,
        colorIndex: p.colorIndex,
        frontPeg: 0,
        backPeg: 0,
      }));
      return {
        players,
        moves: [],
        activePlayerIndex: 0,
        isGameOver: false,
        winnerIndex: null,
        playerCount: players.length,
        dealerIndex: 0,
      };
    }

    case "LOAD_STATE":
      return action.state;

    default:
      return state;
  }
}
