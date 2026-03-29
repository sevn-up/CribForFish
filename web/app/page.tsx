import { GameProvider } from "@/components/game-provider";
import { GameView } from "@/components/game-view";

export default function Home() {
  return (
    <GameProvider>
      <GameView />
    </GameProvider>
  );
}
