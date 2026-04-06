//
//  SavedFoodsSingleton.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 04.04.26.
//

import Foundation
import SwiftData

@Model
class SavedFoodsSingleton {
    
    private var savedFoods: [Food] = []
    init() {}
    
    public func getSavedFoods() -> [Food] {
        return savedFoods
    }
    
    public func addSavedFood(food: Food) {
        savedFoods.append(food)
        savedFoods.sort(by: { $0.productName! < $1.productName! })
    }
    
}
