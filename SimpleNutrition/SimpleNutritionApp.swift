//
//  SimpleNutritionApp.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 30.08.25.
//

import SwiftUI
import SwiftData

@main
struct SimpleNutritionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Food.self, Tag.self, NutritionData.self, SavedFood.self])
    }
}
