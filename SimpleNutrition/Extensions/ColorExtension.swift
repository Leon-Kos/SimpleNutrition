//
//  ColorViewExtension.swift
//  SimpleNutrition
//
//

import SwiftUI

extension Color {
    
    static func darkBackground() -> Color {
        Color(red: 0.1, green: 0.1, blue: 0.18)
    }
    
    static func brightBackground() -> Color {
        Color(red: 0.2, green: 0.2, blue: 0.3)
    }
    
    static func nutriScore(nutri: String) -> Color {
        let score = nutri.uppercased()
        switch score {
        case "A": return Color(red: 0.0, green: 0.3, blue: 0.0)
        case "B": return Color(red: 0.0, green: 0.7, blue: 0.0)
        case "C": return .yellow
        case "D": return Color(red: 1.0, green: 0.6, blue: 0.0)
        case "E": return .red
        default:  return .black
        }
    }
    
    static func colorMode() -> Color {
        let scheme = UITraitCollection.current.userInterfaceStyle
        return scheme == .dark ? .white : .black
    }
    
    static func colorKohlenhydrate() -> Color {
        let scheme = UITraitCollection.current.userInterfaceStyle
        return scheme == .dark ? Color(red: 0.749, green: 0.722, blue: 0.961) : Color(red: 0.282, green: 0.239, blue: 0.671)
    }
    
    static func colorProtein() -> Color {
        let scheme = UITraitCollection.current.userInterfaceStyle
        return scheme == .dark ? Color(red: 0.400, green: 0.839, blue: 0.690) : Color(red: 0.047, green: 0.373, blue: 0.282)
    }
    
    static func colorFett() -> Color {
        let scheme = UITraitCollection.current.userInterfaceStyle
        return scheme == .dark ? Color(red: 0.969, green: 0.812, blue: 0.490) : Color(red: 0.651, green: 0.388, blue: 0.047)
    }
    
    static func colorWasser() -> Color {
        let scheme = UITraitCollection.current.userInterfaceStyle
        return scheme == .dark ? Color(red: 0.420, green: 0.690, blue: 0.949) : Color(red: 0.071, green: 0.318, blue: 0.569)
    }
}
