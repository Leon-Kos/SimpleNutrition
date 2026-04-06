//
//  Tag.swift
//  SimpleNutrition
//
//

import Foundation
import SwiftData

@Model
class Tag: Identifiable {
    
    var id = UUID()
    
    var tracked: [Food]
    
    var date: Date
    
    var kohlenhydrate: Double = 0.0
    var protein: Double = 0.0
    var fett: Double = 0.0
    var ballaststoffe: Double = 0.0
    var salz: Double = 0.0
    var zucker: Double = 0.0
    var kalorien: Double = 0.0
    var wasser: Double = 0.0
    
    var maxKohlenhydrate: Double
    var maxProtein: Double
    var maxFett: Double
    var maxKalorien: Double
    
    var progress_kcal: Double
    var progress_kh: Double
    var progress_p: Double
    var progress_f: Double
    var progress_w: Double
    
    init(maxK: Double, maxP: Double, maxF: Double) {
        self.date = Date()
        self.maxKohlenhydrate = maxK
        self.maxProtein = maxP
        self.maxFett = maxF
        self.maxKalorien = maxK * 4 + maxP * 4 + maxF * 9
        self.tracked = []
        self.progress_kcal = 0.0
        self.progress_kh = 0.0
        self.progress_p = 0.0
        self.progress_f = 0.0
        self.progress_w = 0.0
    }
    
    public func getDateAsString() -> String {
        let date = self.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    public func getDateHeader() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat = "EEEE, dd. MMMM"

        let formatted = formatter.string(from: date)
        return formatted.uppercased()
    }

    
    public func getTracked() -> [Food] {
        return self.tracked
    }

    
    public func addFood(food: Food) {
        tracked.append(food)
        
        kohlenhydrate += Double(food.scaledCarbohydrates ?? 0.0)
        protein += Double(food.scaledProteins ?? 0.0)
        fett += Double(food.scaledFat ?? 0.0)
        ballaststoffe += Double(food.scaledFiber ?? 0.0)
        salz += Double(food.scaledSalt ?? 0.0)
        zucker += Double(food.scaledSugars ?? 0.0)
        kalorien += Double(food.scaledEnergyKcal ?? 0.0)
        
        self.updateProgress()
        
    }
    
    public func addWater(amount: Int) {
        wasser += Double(amount)
    }
    
    public func removeFood(food: Food) {
        kohlenhydrate -= Double(food.scaledCarbohydrates ?? 0.0)
        protein -= Double(food.scaledProteins ?? 0.0)
        fett -= Double(food.scaledFat ?? 0.0)
        ballaststoffe -= Double(food.scaledFiber ?? 0.0)
        salz -= Double(food.scaledSalt ?? 0.0)
        zucker -= Double(food.scaledSugars ?? 0.0)
        kalorien -= Double(food.scaledEnergyKcal ?? 0.0)
        
        for f in tracked {
            if f.id == food.id {
                tracked.removeAll(where: { $0.id == food.id })
            }
        }
        self.updateProgress()
    }
    
    public func adjustNutrients(maxK: Int, maxP: Int, maxF: Int) {
        self.maxKohlenhydrate = Double(maxK)
        self.maxProtein = Double(maxP)
        self.maxFett = Double(maxF)
        self.maxKalorien = Double(maxK * 4 + maxP * 4 + maxF * 9)
        
        
    }
    
    private func updateProgress() {
        if (self.maxKalorien == 0) {
            progress_kcal = 0.0
        } else if (self.kalorien >= self.maxKalorien) {
            progress_kcal = 1.0
        } else {
            progress_kcal = Double(self.kalorien) / Double(self.maxKalorien)
        }
        
        
        if (self.maxKohlenhydrate == 0) {
            progress_kh = 0.0
        } else if (self.kohlenhydrate >= self.maxKohlenhydrate) {
            progress_kh = 1.0
        } else {
            progress_kh = Double(self.kohlenhydrate) / Double(self.maxKohlenhydrate)
        }
        
        
        if (self.maxProtein == 0) {
            progress_p = 0.0
        } else if self.protein >= self.maxProtein {
            progress_p = 1.0
        } else {
            progress_p = Double(self.protein) / Double(self.maxProtein)
        }
        

        if (self.maxFett == 0) {
            progress_f = 0.0
        } else if self.fett >= self.maxFett {
            progress_f = 1.0
        } else {
            progress_f = Double(self.fett) / Double(self.maxFett)
        }
    }
    
    public func getProgress() -> [String:Double] {
        let progress = [
            "kcal" : progress_kcal,
            "kh"   : progress_kh,
            "p"    : progress_p,
            "f"    : progress_f,
            "w"    : progress_w
        ]
        return progress
    }
    
}

