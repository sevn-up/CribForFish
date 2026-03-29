import type { MetadataRoute } from "next";

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "Crib for Fish",
    short_name: "CribForFish",
    description: "A digital cribbage board for keeping score",
    start_url: "/",
    display: "standalone",
    background_color: "#2e1c0f",
    theme_color: "#2e1c0f",
    icons: [
      {
        src: "/icon.svg",
        sizes: "any",
        type: "image/svg+xml",
      },
    ],
  };
}
