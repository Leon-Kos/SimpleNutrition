//
//  FoodExtension.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 30.03.26.
//

extension Food {
    func copy() -> Food {
        return Food(
            code: self.code,
            productName: self.productName,
            brands: self.brands,
            quantity: self.quantity,
            categories: self.categories,
            nutriscoreGrade: self.nutriscoreGrade,
            imageUrl: self.imageUrl,
            energyKcal100g: self.energyKcal100g,
            fat100g: self.fat100g,
            saturatedFat100g: self.saturatedFat100g,
            carbohydrates100g: self.carbohydrates100g,
            fiber100g: self.fiber100g,
            sugars100g: self.sugars100g,
            proteins100g: self.proteins100g,
            salt100g: self.salt100g,
            scaledQuantity: self.scaledQuantity,
            scaledEnergyKcal: self.scaledEnergyKcal,
            scaledFat: self.scaledFat,
            scaledSaturatedFat: self.scaledSaturatedFat,
            scaledCarbohydrates: self.scaledCarbohydrates,
            scaledFiber: self.scaledFiber,
            scaledSugars: self.scaledSugars,
            scaledProteins: self.scaledProteins,
            scaledSalt: self.scaledSalt
        )
        
    }
}
