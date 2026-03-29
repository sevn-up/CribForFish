import { ImageResponse } from "next/og";

export const runtime = "edge";

export const alt = "Crib for Fish — Digital Cribbage Board";
export const size = { width: 1200, height: 630 };
export const contentType = "image/png";

export default function Image() {
  const pegHoles = Array.from({ length: 12 }, (_, i) => i);
  // Some pegs are "filled" for visual interest
  const redPegAt = 3;
  const bluePegAt = 5;

  return new ImageResponse(
    (
      <div
        style={{
          width: "100%",
          height: "100%",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          background: "linear-gradient(135deg, #47341a 0%, #33200f 50%, #2e1c0f 100%)",
          fontFamily: "system-ui, sans-serif",
          position: "relative",
          overflow: "hidden",
        }}
      >
        {/* Subtle wood grain lines */}
        {Array.from({ length: 8 }, (_, i) => (
          <div
            key={i}
            style={{
              position: "absolute",
              left: 0,
              right: 0,
              top: `${10 + i * 12}%`,
              height: 1,
              background: `rgba(217, 166, 77, ${0.03 + i * 0.005})`,
            }}
          />
        ))}

        {/* Gold accent border */}
        <div
          style={{
            position: "absolute",
            inset: 20,
            border: "2px solid rgba(217, 166, 77, 0.2)",
            borderRadius: 24,
            display: "flex",
          }}
        />

        {/* Title */}
        <div
          style={{
            fontSize: 72,
            fontWeight: 800,
            color: "#f2e6d1",
            letterSpacing: "-1px",
            display: "flex",
          }}
        >
          Crib for Fish
        </div>

        {/* Subtitle */}
        <div
          style={{
            fontSize: 28,
            color: "#bfa685",
            marginTop: 8,
            display: "flex",
          }}
        >
          Digital Cribbage Board
        </div>

        {/* Peg row */}
        <div
          style={{
            display: "flex",
            gap: 20,
            marginTop: 48,
            alignItems: "center",
          }}
        >
          {pegHoles.map((i) => (
            <div
              key={i}
              style={{
                display: "flex",
                flexDirection: "column",
                gap: 8,
                alignItems: "center",
              }}
            >
              {/* Player 1 track */}
              <div
                style={{
                  width: i === redPegAt ? 20 : 14,
                  height: i === redPegAt ? 20 : 14,
                  borderRadius: "50%",
                  background:
                    i === redPegAt
                      ? "#e64033"
                      : "rgba(140, 115, 89, 0.4)",
                  boxShadow:
                    i === redPegAt
                      ? "0 0 12px rgba(230, 64, 51, 0.6)"
                      : "none",
                  display: "flex",
                }}
              />
              {/* Player 2 track */}
              <div
                style={{
                  width: i === bluePegAt ? 20 : 14,
                  height: i === bluePegAt ? 20 : 14,
                  borderRadius: "50%",
                  background:
                    i === bluePegAt
                      ? "#4d99ff"
                      : "rgba(140, 115, 89, 0.4)",
                  boxShadow:
                    i === bluePegAt
                      ? "0 0 12px rgba(77, 153, 255, 0.6)"
                      : "none",
                  display: "flex",
                }}
              />
            </div>
          ))}
        </div>

        {/* Accent gold fish silhouette */}
        <div
          style={{
            position: "absolute",
            bottom: 30,
            right: 40,
            fontSize: 24,
            color: "rgba(217, 166, 77, 0.3)",
            display: "flex",
          }}
        >
          cribforfish.vercel.app
        </div>
      </div>
    ),
    { ...size }
  );
}
