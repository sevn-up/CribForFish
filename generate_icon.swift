#!/usr/bin/env swift

import Cocoa
import CoreGraphics

let size: CGFloat = 1024
let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: Int(size),
    pixelsHigh: Int(size),
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
)!

NSGraphicsContext.saveGraphicsState()
let ctx = NSGraphicsContext(bitmapImageRep: rep)!
NSGraphicsContext.current = ctx
let cg = ctx.cgContext

// === BACKGROUND: Warm wood gradient ===
let bgColors: [CGFloat] = [
    0.28, 0.18, 0.10, 1.0,  // warm brown (top) - matches BoardTheme
    0.22, 0.14, 0.08, 1.0,  // medium brown (mid)
    0.18, 0.11, 0.06, 1.0,  // dark brown (bottom)
]
let bgGradient = CGGradient(
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    colorComponents: bgColors,
    locations: [0.0, 0.5, 1.0],
    count: 3
)!
cg.drawLinearGradient(bgGradient, start: CGPoint(x: 512, y: 1024), end: CGPoint(x: 512, y: 0), options: [])

// === SUBTLE WOOD GRAIN ===
for i in 0..<12 {
    let y = CGFloat(60 + i * 85)
    let alpha: CGFloat = 0.03 + CGFloat(i % 3) * 0.01
    cg.setStrokeColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: alpha))
    cg.setLineWidth(1.5)
    cg.beginPath()
    cg.move(to: CGPoint(x: -20, y: y))
    for x in stride(from: -20, through: 1044, by: 2) {
        let xf = CGFloat(x)
        let yOff = sin(xf * 0.004 + CGFloat(i) * 1.2) * 8 + sin(xf * 0.01) * 3
        cg.addLine(to: CGPoint(x: xf, y: y + yOff))
    }
    cg.strokePath()
}

// === ACCENT BORDER (subtle gold inset) ===
let inset: CGFloat = 60
let borderRect = CGRect(x: inset, y: inset, width: size - inset * 2, height: size - inset * 2)
let borderPath = CGPath(roundedRect: borderRect, cornerWidth: 40, cornerHeight: 40, transform: nil)
cg.setStrokeColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.15))
cg.setLineWidth(2)
cg.addPath(borderPath)
cg.strokePath()

// === CRIBBAGE BOARD: Two columns of pegs (center) ===
let boardCenterX: CGFloat = 512
let boardTopY: CGFloat = 220
let colSpacing: CGFloat = 80
let rowSpacing: CGFloat = 56
let numRows = 8

let colOffsets: [CGFloat] = [boardCenterX - colSpacing/2, boardCenterX + colSpacing/2]
let playerColors: [(CGFloat, CGFloat, CGFloat)] = [
    (0.90, 0.25, 0.20),   // red - matches PlayerColor.red
    (0.30, 0.60, 1.0),    // blue - matches PlayerColor.blue
]

// Red peg position (row 4 in left col), Blue peg position (row 5 in right col)
let redPegRow = 4
let bluePegRow = 5

for (colIdx, colX) in colOffsets.enumerated() {
    for row in 0..<numRows {
        let holeY = boardTopY + CGFloat(row) * rowSpacing
        let isRedPeg = colIdx == 0 && row == redPegRow
        let isBluePeg = colIdx == 1 && row == bluePegRow

        if isRedPeg || isBluePeg {
            // Filled peg with glow
            let color = isRedPeg ? playerColors[0] : playerColors[1]
            let pegR: CGFloat = 16

            // Outer glow
            cg.setFillColor(CGColor(red: color.0, green: color.1, blue: color.2, alpha: 0.25))
            cg.fillEllipse(in: CGRect(x: colX - pegR - 6, y: holeY - pegR - 6, width: (pegR + 6) * 2, height: (pegR + 6) * 2))

            // Peg body
            cg.setFillColor(CGColor(red: color.0, green: color.1, blue: color.2, alpha: 1.0))
            cg.fillEllipse(in: CGRect(x: colX - pegR, y: holeY - pegR, width: pegR * 2, height: pegR * 2))

            // Highlight dot (top-right shine)
            cg.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.35))
            cg.fillEllipse(in: CGRect(x: colX - 4, y: holeY + 3, width: 8, height: 8))
        } else {
            // Empty hole
            let holeR: CGFloat = 10
            cg.setFillColor(CGColor(red: 0.55, green: 0.45, blue: 0.35, alpha: 0.35))
            cg.fillEllipse(in: CGRect(x: colX - holeR, y: holeY - holeR, width: holeR * 2, height: holeR * 2))
            // Inner shadow
            cg.setFillColor(CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.12))
            cg.fillEllipse(in: CGRect(x: colX - holeR + 2, y: holeY - holeR + 2, width: holeR * 2 - 4, height: holeR * 2 - 4))
        }
    }
}

// === SUBTLE DIVIDER LINE between peg columns ===
cg.setStrokeColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.12))
cg.setLineWidth(1.5)
cg.beginPath()
cg.move(to: CGPoint(x: boardCenterX, y: boardTopY - 20))
cg.addLine(to: CGPoint(x: boardCenterX, y: boardTopY + CGFloat(numRows - 1) * rowSpacing + 20))
cg.strokePath()

// === SMALL GOLD FISH SILHOUETTE (bottom center) ===
let fishX: CGFloat = 512
let fishY: CGFloat = 780
let fishScale: CGFloat = 0.7

cg.saveGState()
cg.translateBy(x: fishX, y: fishY)
cg.scaleBy(x: fishScale, y: fishScale)

// Fish body
let fishBody = CGMutablePath()
fishBody.move(to: CGPoint(x: -60, y: 0))
fishBody.addCurve(to: CGPoint(x: 60, y: 0),
                  control1: CGPoint(x: -20, y: -40),
                  control2: CGPoint(x: 30, y: -45))
fishBody.addCurve(to: CGPoint(x: -60, y: 0),
                  control1: CGPoint(x: 30, y: 45),
                  control2: CGPoint(x: -20, y: 40))
fishBody.closeSubpath()

cg.setFillColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.35))
cg.addPath(fishBody)
cg.fillPath()

// Tail
let tail = CGMutablePath()
tail.move(to: CGPoint(x: -55, y: 0))
tail.addCurve(to: CGPoint(x: -90, y: -30),
              control1: CGPoint(x: -65, y: -5),
              control2: CGPoint(x: -75, y: -25))
tail.addCurve(to: CGPoint(x: -55, y: 0),
              control1: CGPoint(x: -80, y: -10),
              control2: CGPoint(x: -60, y: 0))
tail.addCurve(to: CGPoint(x: -90, y: 30),
              control1: CGPoint(x: -60, y: 0),
              control2: CGPoint(x: -80, y: 10))
tail.addCurve(to: CGPoint(x: -55, y: 0),
              control1: CGPoint(x: -75, y: 25),
              control2: CGPoint(x: -65, y: 5))
tail.closeSubpath()
cg.setFillColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.30))
cg.addPath(tail)
cg.fillPath()

// Eye
cg.setFillColor(CGColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.5))
cg.fillEllipse(in: CGRect(x: 30, y: -10, width: 12, height: 12))

cg.restoreGState()

// === TEXT: "CRIB" at the top ===
let textAttrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 110, weight: .heavy),
    .foregroundColor: NSColor(red: 0.95, green: 0.90, blue: 0.82, alpha: 0.95),
]
let text = NSAttributedString(string: "CRIB", attributes: textAttrs)
let textSize = text.size()
let textX = (size - textSize.width) / 2
let textY = size - 180  // top area (CoreGraphics y is flipped)
text.draw(at: NSPoint(x: textX, y: textY))

// === "for Fish" subtitle ===
let subAttrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 48, weight: .medium),
    .foregroundColor: NSColor(red: 0.85, green: 0.65, blue: 0.30, alpha: 0.8),
]
let subText = NSAttributedString(string: "for Fish", attributes: subAttrs)
let subSize = subText.size()
let subX = (size - subSize.width) / 2
let subY = textY - 55
subText.draw(at: NSPoint(x: subX, y: subY))

NSGraphicsContext.restoreGraphicsState()

// Save PNG
let iconDir = "/Volumes/T7/GitHub/CribForFish/CribForFish/Assets.xcassets/AppIcon.appiconset"
let pngData = rep.representation(using: .png, properties: [:])!
let url = URL(fileURLWithPath: "\(iconDir)/AppIcon.png")
try! pngData.write(to: url)

// Dark variant (same — warm brown works great on dark backgrounds)
let darkUrl = URL(fileURLWithPath: "\(iconDir)/AppIcon-dark.png")
try! pngData.write(to: darkUrl)

// Tinted variant
let tintedUrl = URL(fileURLWithPath: "\(iconDir)/AppIcon-tinted.png")
try! pngData.write(to: tintedUrl)

print("✓ Icons generated successfully!")
print("  → \(url.path)")
print("  → \(darkUrl.path)")
print("  → \(tintedUrl.path)")
