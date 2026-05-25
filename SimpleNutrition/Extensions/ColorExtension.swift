import SwiftUI

extension Color {

    // ── Design tokens ─────────────────────────────────────────────
    static let snBackground = Color(red: 0.957, green: 0.937, blue: 0.910) // #f4efe8
    static let snCard       = Color.white
    static let snInk        = Color(red: 0.110, green: 0.165, blue: 0.125) // #1c2a20
    static let snInk2       = Color(red: 0.341, green: 0.396, blue: 0.376) // #576560
    static let snInk3       = Color(red: 0.541, green: 0.580, blue: 0.561) // #8a948f
    static let snPrimary    = Color(red: 0.184, green: 0.420, blue: 0.239) // #2f6b3d
    static let snTint       = Color(red: 0.914, green: 0.941, blue: 0.890) // #e9f0e3
    static let snSoft       = Color(red: 0.784, green: 0.851, blue: 0.749) // #c8d9bf
    static let snDeep       = Color(red: 0.110, green: 0.165, blue: 0.125) // #1c2a20
    static let snWarn       = Color(red: 0.773, green: 0.290, blue: 0.227) // #c54a3a
    static let snProtein    = Color(red: 0.784, green: 0.478, blue: 0.290) // #c87a4a
    static let snCarbs      = Color(red: 0.851, green: 0.659, blue: 0.310) // #d9a84f
    static let snFat        = Color(red: 0.435, green: 0.604, blue: 0.549) // #6f9a8c

    // ── Legacy macro helpers ───────────────────────────────────────
    static func colorKohlenhydrate() -> Color { .snCarbs }
    static func colorProtein() -> Color { .snProtein }
    static func colorFett() -> Color { .snFat }
    static func colorWasser() -> Color { .snPrimary }

    static func colorMode() -> Color {
        UITraitCollection.current.userInterfaceStyle == .dark ? .white : .snInk
    }

    static func nutriScore(nutri: String) -> Color {
        switch nutri.uppercased() {
        case "A": return Color(red: 0.0,  green: 0.40, blue: 0.10)
        case "B": return Color(red: 0.20, green: 0.60, blue: 0.20)
        case "C": return Color(red: 0.80, green: 0.70, blue: 0.10)
        case "D": return Color(red: 0.85, green: 0.45, blue: 0.10)
        case "E": return .snWarn
        default:  return .snInk3
        }
    }

    // ── Kept for backward compatibility ───────────────────────────
    static func darkBackground() -> Color { Color(red: 0.1, green: 0.1, blue: 0.18) }
    static func brightBackground() -> Color { Color(red: 0.2, green: 0.2, blue: 0.3) }
}
