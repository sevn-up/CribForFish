import type { Metadata, Viewport } from "next";
import { Geist } from "next/font/google";
import "./globals.css";

const geist = Geist({
  subsets: ["latin"],
});

export const metadata: Metadata = {
  metadataBase: new URL("https://crib-for-fish.vercel.app"),
  title: "Crib for Fish",
  description: "A digital cribbage board for keeping score",
  appleWebApp: {
    capable: true,
    statusBarStyle: "black-translucent",
    title: "Crib for Fish",
  },
  openGraph: {
    title: "Crib for Fish",
    description: "A digital cribbage board for keeping score with friends",
    type: "website",
    siteName: "Crib for Fish",
  },
  twitter: {
    card: "summary_large_image",
    title: "Crib for Fish",
    description: "A digital cribbage board for keeping score with friends",
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  maximumScale: 1,
  userScalable: false,
  themeColor: "#2e1c0f",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={geist.className}>
      <body>{children}</body>
    </html>
  );
}
