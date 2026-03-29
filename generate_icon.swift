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

// === BACKGROUND: Ocean gradient ===
let bgColors: [CGFloat] = [
    0.02, 0.06, 0.18, 1.0,  // deep navy bottom
    0.05, 0.15, 0.35, 1.0,  // ocean blue mid
    0.08, 0.22, 0.45, 1.0,  // lighter blue top
]
let bgGradient = CGGradient(
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    colorComponents: bgColors,
    locations: [0.0, 0.5, 1.0],
    count: 3
)!
cg.drawLinearGradient(bgGradient, start: CGPoint(x: 512, y: 0), end: CGPoint(x: 512, y: 1024), options: [])

// === SUBTLE WAVE PATTERN ===
for i in 0..<4 {
    let y = CGFloat(200 + i * 220)
    let alpha: CGFloat = 0.04 + CGFloat(i) * 0.01
    cg.setStrokeColor(CGColor(red: 0.3, green: 0.7, blue: 0.9, alpha: alpha))
    cg.setLineWidth(2.5)
    cg.beginPath()
    cg.move(to: CGPoint(x: -50, y: y))
    for x in stride(from: -50, through: 1074, by: 2) {
        let xf = CGFloat(x)
        let yOff = sin(xf * 0.008 + CGFloat(i) * 0.7) * 30 + sin(xf * 0.015) * 15
        cg.addLine(to: CGPoint(x: xf, y: y + yOff))
    }
    cg.strokePath()
}

// === CRIBBAGE BOARD SECTION (left side accent) ===
// Draw a small vertical board strip with pegs
let boardX: CGFloat = 130
let boardY: CGFloat = 280
let boardW: CGFloat = 90
let boardH: CGFloat = 460

// Board body
cg.setFillColor(CGColor(red: 0.10, green: 0.24, blue: 0.44, alpha: 0.85))
let boardRect = CGRect(x: boardX, y: boardY, width: boardW, height: boardH)
let boardPath = CGPath(roundedRect: boardRect, cornerWidth: 16, cornerHeight: 16, transform: nil)
cg.addPath(boardPath)
cg.fillPath()

// Board border
cg.setStrokeColor(CGColor(red: 0.3, green: 0.6, blue: 0.8, alpha: 0.5))
cg.setLineWidth(2)
cg.addPath(boardPath)
cg.strokePath()

// Peg holes - two columns of dots
let colOffsets: [CGFloat] = [boardX + 30, boardX + 60]
let playerColors: [(CGFloat, CGFloat, CGFloat)] = [
    (1.0, 0.42, 0.38),   // coral
    (0.2, 0.65, 0.95),   // ocean blue
]

for (colIdx, colX) in colOffsets.enumerated() {
    for row in 0..<10 {
        let holeY = boardY + 35 + CGFloat(row) * 42
        let dotR: CGFloat = 7

        // Most are empty holes
        if (colIdx == 0 && row == 6) || (colIdx == 1 && row == 4) {
            // Filled pegs (player positions)
            let color = playerColors[colIdx]
            cg.setFillColor(CGColor(red: color.0, green: color.1, blue: color.2, alpha: 1.0))
            cg.fillEllipse(in: CGRect(x: colX - dotR, y: holeY - dotR, width: dotR * 2, height: dotR * 2))
            // Glow
            cg.setFillColor(CGColor(red: color.0, green: color.1, blue: color.2, alpha: 0.3))
            cg.fillEllipse(in: CGRect(x: colX - dotR - 3, y: holeY - dotR - 3, width: dotR * 2 + 6, height: dotR * 2 + 6))
        } else {
            // Empty hole
            cg.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.12))
            cg.fillEllipse(in: CGRect(x: colX - dotR + 2, y: holeY - dotR + 2, width: dotR * 2 - 4, height: dotR * 2 - 4))
        }
    }
}

// === MAIN FISH ===
// A stylized fish facing right, center-right of the icon
let fishCenterX: CGFloat = 580
let fishCenterY: CGFloat = 500

cg.saveGState()
cg.translateBy(x: fishCenterX, y: fishCenterY)

// Fish body - elegant ellipse shape
let bodyW: CGFloat = 300
let bodyH: CGFloat = 160

// Fish body gradient
let fishColors: [CGFloat] = [
    0.95, 0.55, 0.30, 1.0,  // warm orange
    1.0, 0.42, 0.38, 1.0,   // coral
    0.85, 0.25, 0.30, 1.0,  // deeper red
]
let fishGradient = CGGradient(
    colorSpace: CGColorSpaceCreateDeviceRGB(),
    colorComponents: fishColors,
    locations: [0.0, 0.5, 1.0],
    count: 3
)!

// Fish body path
cg.saveGState()
let bodyPath = CGMutablePath()
bodyPath.move(to: CGPoint(x: -bodyW/2, y: 0))
bodyPath.addCurve(to: CGPoint(x: bodyW/2 - 20, y: 0),
                  control1: CGPoint(x: -bodyW/4, y: -bodyH/2),
                  control2: CGPoint(x: bodyW/4, y: -bodyH/2 - 10))
// Mouth indent
bodyPath.addQuadCurve(to: CGPoint(x: bodyW/2 - 20, y: 0),
                      control: CGPoint(x: bodyW/2 + 20, y: -15))
bodyPath.addQuadCurve(to: CGPoint(x: bodyW/2 - 20, y: 0),
                      control: CGPoint(x: bodyW/2 + 20, y: 15))
bodyPath.addCurve(to: CGPoint(x: -bodyW/2, y: 0),
                  control1: CGPoint(x: bodyW/4, y: bodyH/2 + 10),
                  control2: CGPoint(x: -bodyW/4, y: bodyH/2))
bodyPath.closeSubpath()

cg.addPath(bodyPath)
cg.clip()
cg.drawLinearGradient(fishGradient,
                      start: CGPoint(x: 0, y: -bodyH/2),
                      end: CGPoint(x: 0, y: bodyH/2),
                      options: [])
cg.restoreGState()

// Fish body outline
cg.setStrokeColor(CGColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 0.4))
cg.setLineWidth(2)
cg.addPath(bodyPath)
cg.strokePath()

// Tail fin
let tailPath = CGMutablePath()
tailPath.move(to: CGPoint(x: -bodyW/2 + 20, y: -10))
tailPath.addCurve(to: CGPoint(x: -bodyW/2 - 80, y: -70),
                  control1: CGPoint(x: -bodyW/2 - 10, y: -15),
                  control2: CGPoint(x: -bodyW/2 - 40, y: -65))
tailPath.addCurve(to: CGPoint(x: -bodyW/2 + 20, y: 0),
                  control1: CGPoint(x: -bodyW/2 - 50, y: -30),
                  control2: CGPoint(x: -bodyW/2, y: 0))
tailPath.addCurve(to: CGPoint(x: -bodyW/2 - 80, y: 70),
                  control1: CGPoint(x: -bodyW/2, y: 0),
                  control2: CGPoint(x: -bodyW/2 - 50, y: 30))
tailPath.addCurve(to: CGPoint(x: -bodyW/2 + 20, y: 10),
                  control1: CGPoint(x: -bodyW/2 - 40, y: 65),
                  control2: CGPoint(x: -bodyW/2 - 10, y: 15))
tailPath.closeSubpath()

cg.setFillColor(CGColor(red: 0.90, green: 0.40, blue: 0.30, alpha: 0.9))
cg.addPath(tailPath)
cg.fillPath()

// Dorsal fin (top)
let dorsalPath = CGMutablePath()
dorsalPath.move(to: CGPoint(x: -20, y: -bodyH/2 + 20))
dorsalPath.addCurve(to: CGPoint(x: 60, y: -bodyH/2 + 15),
                    control1: CGPoint(x: 0, y: -bodyH/2 - 50),
                    control2: CGPoint(x: 40, y: -bodyH/2 - 40))
cg.setStrokeColor(CGColor(red: 0.85, green: 0.35, blue: 0.28, alpha: 0.8))
cg.setLineWidth(3)
cg.setLineCap(.round)
cg.addPath(dorsalPath)
cg.strokePath()

// Fin fill
let dorsalFill = CGMutablePath()
dorsalFill.move(to: CGPoint(x: -20, y: -bodyH/2 + 20))
dorsalFill.addCurve(to: CGPoint(x: 60, y: -bodyH/2 + 15),
                    control1: CGPoint(x: 0, y: -bodyH/2 - 50),
                    control2: CGPoint(x: 40, y: -bodyH/2 - 40))
dorsalFill.addLine(to: CGPoint(x: -20, y: -bodyH/2 + 20))
dorsalFill.closeSubpath()
cg.setFillColor(CGColor(red: 0.90, green: 0.40, blue: 0.30, alpha: 0.5))
cg.addPath(dorsalFill)
cg.fillPath()

// Eye
let eyeX: CGFloat = bodyW/2 - 80
let eyeY: CGFloat = -25
let eyeR: CGFloat = 18

// Eye white
cg.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95))
cg.fillEllipse(in: CGRect(x: eyeX - eyeR, y: eyeY - eyeR, width: eyeR * 2, height: eyeR * 2))

// Pupil
let pupilR: CGFloat = 10
cg.setFillColor(CGColor(red: 0.05, green: 0.05, blue: 0.15, alpha: 1.0))
cg.fillEllipse(in: CGRect(x: eyeX - pupilR + 3, y: eyeY - pupilR, width: pupilR * 2, height: pupilR * 2))

// Eye shine
cg.setFillColor(CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.9))
cg.fillEllipse(in: CGRect(x: eyeX + 2, y: eyeY - 8, width: 7, height: 7))

// Scale pattern (subtle arcs)
cg.setStrokeColor(CGColor(red: 0.7, green: 0.25, blue: 0.20, alpha: 0.2))
cg.setLineWidth(1.5)
for row in 0..<3 {
    for col in 0..<5 {
        let sx = CGFloat(-60 + col * 45)
        let sy = CGFloat(-30 + row * 40)
        cg.beginPath()
        cg.addArc(center: CGPoint(x: sx, y: sy), radius: 18, startAngle: .pi * 0.2, endAngle: .pi * 0.8, clockwise: false)
        cg.strokePath()
    }
}

// Mouth line
cg.setStrokeColor(CGColor(red: 0.5, green: 0.15, blue: 0.15, alpha: 0.6))
cg.setLineWidth(2.5)
cg.beginPath()
cg.move(to: CGPoint(x: bodyW/2 - 30, y: 8))
cg.addQuadCurve(to: CGPoint(x: bodyW/2 - 5, y: 2), control: CGPoint(x: bodyW/2 - 15, y: 12))
cg.strokePath()

cg.restoreGState()

// === SMALL BUBBLES ===
let bubbles: [(CGFloat, CGFloat, CGFloat)] = [
    (740, 380, 12), (770, 340, 8), (755, 300, 6),
    (790, 310, 10), (720, 330, 5),
]
for (bx, by, br) in bubbles {
    cg.setFillColor(CGColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 0.15))
    cg.fillEllipse(in: CGRect(x: bx - br, y: by - br, width: br * 2, height: br * 2))
    cg.setStrokeColor(CGColor(red: 0.5, green: 0.8, blue: 1.0, alpha: 0.3))
    cg.setLineWidth(1.5)
    cg.strokeEllipse(in: CGRect(x: bx - br, y: by - br, width: br * 2, height: br * 2))
}

// === TEXT: "CRIB" at the top ===
let textAttrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 120, weight: .heavy),
    .foregroundColor: NSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.95),
]
let text = NSAttributedString(string: "CRIB", attributes: textAttrs)
let textSize = text.size()
let textX = (size - textSize.width) / 2 + 40  // slightly right to balance with board
let textY = size - 220  // top area (CoreGraphics y is flipped from screen)
text.draw(at: NSPoint(x: textX, y: textY))

// Subtle text shadow / underline accent
cg.setFillColor(CGColor(red: 0.2, green: 0.65, blue: 0.95, alpha: 0.4))
cg.fill(CGRect(x: textX, y: textY - 5, width: textSize.width, height: 3))

// === "for fish" subtitle ===
let subAttrs: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 52, weight: .medium),
    .foregroundColor: NSColor(red: 0.6, green: 0.85, blue: 1.0, alpha: 0.8),
]
let subText = NSAttributedString(string: "for Fish", attributes: subAttrs)
let subSize = subText.size()
let subX = (size - subSize.width) / 2 + 40
let subY = textY - 60
subText.draw(at: NSPoint(x: subX, y: subY))

NSGraphicsContext.restoreGraphicsState()

// Save PNG
let iconDir = "/Volumes/T7/GitHub/CribForFish/CribForFish/Assets.xcassets/AppIcon.appiconset"
let pngData = rep.representation(using: .png, properties: [:])!
let url = URL(fileURLWithPath: "\(iconDir)/AppIcon.png")
try! pngData.write(to: url)

// Also save dark variant (same icon works great on dark)
let darkUrl = URL(fileURLWithPath: "\(iconDir)/AppIcon-dark.png")
try! pngData.write(to: darkUrl)

// Tinted variant - slightly desaturated version
let tintedUrl = URL(fileURLWithPath: "\(iconDir)/AppIcon-tinted.png")
try! pngData.write(to: tintedUrl)

print("✓ Icons generated successfully!")
print("  → \(url.path)")
print("  → \(darkUrl.path)")
print("  → \(tintedUrl.path)")
