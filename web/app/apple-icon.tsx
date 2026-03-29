import { ImageResponse } from "next/og";

export const size = { width: 180, height: 180 };
export const contentType = "image/png";

export default function Icon() {
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
          background: "linear-gradient(135deg, #47341a 0%, #33200f 100%)",
          borderRadius: 36,
          position: "relative",
          overflow: "hidden",
        }}
      >
        {/* Subtle grain */}
        {Array.from({ length: 5 }, (_, i) => (
          <div
            key={i}
            style={{
              position: "absolute",
              left: 0,
              right: 0,
              top: `${15 + i * 18}%`,
              height: 1,
              background: `rgba(217, 166, 77, ${0.04})`,
              display: "flex",
            }}
          />
        ))}

        {/* Two columns of peg holes */}
        <div
          style={{
            display: "flex",
            gap: 28,
            alignItems: "center",
          }}
        >
          {/* Left column (5 holes, red peg at position 2) */}
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              gap: 10,
              alignItems: "center",
            }}
          >
            {Array.from({ length: 5 }, (_, i) => (
              <div
                key={i}
                style={{
                  width: i === 2 ? 18 : 14,
                  height: i === 2 ? 18 : 14,
                  borderRadius: "50%",
                  background:
                    i === 2
                      ? "#e64033"
                      : "rgba(140, 115, 89, 0.4)",
                  boxShadow:
                    i === 2
                      ? "0 0 8px rgba(230, 64, 51, 0.5)"
                      : "none",
                  display: "flex",
                }}
              />
            ))}
          </div>

          {/* Right column (5 holes, blue peg at position 3) */}
          <div
            style={{
              display: "flex",
              flexDirection: "column",
              gap: 10,
              alignItems: "center",
            }}
          >
            {Array.from({ length: 5 }, (_, i) => (
              <div
                key={i}
                style={{
                  width: i === 3 ? 18 : 14,
                  height: i === 3 ? 18 : 14,
                  borderRadius: "50%",
                  background:
                    i === 3
                      ? "#4d99ff"
                      : "rgba(140, 115, 89, 0.4)",
                  boxShadow:
                    i === 3
                      ? "0 0 8px rgba(77, 153, 255, 0.5)"
                      : "none",
                  display: "flex",
                }}
              />
            ))}
          </div>
        </div>
      </div>
    ),
    { ...size }
  );
}
