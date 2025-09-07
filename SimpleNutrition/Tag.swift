//
//  Tag.swift
//  SimpleNutrition
//
//

import Foundation
import SwiftData

@Model
class Tag: Identifiable {
    
    var id: Date { date }
    
    var date: Date
    var kohlenhydrate: Double
    var protein: Double
    var fett: Double
    var kalorien: Double
    var tracked: [Food]
    
    var maxKohlenhydrate: Double
    var maxProtein: Double
    var maxFett: Double
    var maxKalorien: Double
    
    init(maxK: Double, maxP: Double, maxF: Double) {
        self.date = Date()
        self.kohlenhydrate = 0
        self.protein = 0
        self.fett = 0
        self.kalorien = 0
        self.maxKohlenhydrate = maxK
        self.maxProtein = maxP
        self.maxFett = maxF
        self.maxKalorien = maxK * 4 + maxP * 4 + maxF * 9
        self.tracked = []
    }
    
    public func adjustNegative(k: Double, p: Double, f: Double, c: Double) {
        self.kohlenhydrate -= k;
        self.protein -= p;
        self.fett -= f;
        self.kalorien -= c;
    }
    
    public func adjustPositive(k: Double, p: Double, f: Double, c: Double) {
        self.kohlenhydrate += k;
        self.protein += p;
        self.fett += f;
        self.kalorien += c;
    }
    
    public func getDateAsString() -> String {
        let date = self.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    
    public func getTracked() -> [Food] {
        return self.tracked
    }
    
    public func addFood(food: Food) {
        tracked.append(food)
        self.kohlenhydrate = 0
        self.protein = 0
        self.fett = 0
        self.kalorien = 0
        
        for food in tracked {
            self.kohlenhydrate += Double(food.carbohydrates100g ?? 0)
            self.protein += Double(food.proteins100g ?? 0)
            self.fett += Double(food.fat100g ?? 0)
            self.kalorien += (Double(food.carbohydrates100g ?? 0) * 4) + (Double(food.proteins100g ?? 0) * 4) + (Double(food.fat100g ?? 0) * 9) + (Double(food.fiber100g ?? 0) * 2)
        }
    }
    
    public func removeFood(at offsets: IndexSet) {
        tracked.remove(atOffsets: offsets)
        self.kohlenhydrate = 0
        self.protein = 0
        self.fett = 0
        self.kalorien = 0
        
        for food in tracked {
            self.kohlenhydrate += Double(food.carbohydrates100g ?? 0)
            self.protein += Double(food.proteins100g ?? 0)
            self.fett += Double(food.fat100g ?? 0)
            self.kalorien += (Double(food.carbohydrates100g ?? 0) * 4) + (Double(food.proteins100g ?? 0) * 4) + (Double(food.fat100g ?? 0) * 9) + Double(food.fiber100g ?? 0) * 2
        }
        
    }
    
}
