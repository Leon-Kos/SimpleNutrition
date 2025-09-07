//
//  NutritionData.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 05.09.25.
//

import Foundation
import SwiftData

@Model
class NutritionData {
    var date: Date
    
    var kohlenhydrate: Double
    var protein: Double
    var fett: Double
    
    init(kohlenhydrate: Double, protein: Double, fett: Double) {
        self.date = Date()
        self.kohlenhydrate = kohlenhydrate
        self.protein = protein
        self.fett = fett
    }
}
