import Foundation
import SwiftData

@Model
class Food: Identifiable {
    
    var id = UUID()

    var code: String?
    var productName: String?
    var brands: String?
    var quantity: String?
    var categories: String?
    var nutriscoreGrade: String?
    var imageUrl: String?

    var energyKcal100g: Double?
    var fat100g: Double?
    var saturatedFat100g: Double?
    var carbohydrates100g: Double?
    var sugars100g: Double?
    var fiber100g: Double?
    var proteins100g: Double?
    var salt100g: Double?
    
    var scaledQuantity: Int?
    var scaledEnergyKcal: Double?
    var scaledFat: Double?
    var scaledSaturatedFat: Double?
    var scaledCarbohydrates: Double?
    var scaledFiber: Double?
    var scaledSugars: Double?
    var scaledProteins: Double?
    var scaledSalt: Double?

    // Initializer
    init(
        code: String? = nil,
        productName: String? = nil,
        brands: String? = nil,
        quantity: String? = nil,
        categories: String? = nil,
        nutriscoreGrade: String? = nil,
        imageUrl: String? = nil,
        energyKcal100g: Double? = nil,
        fat100g: Double? = nil,
        saturatedFat100g: Double? = nil,
        carbohydrates100g: Double? = nil,
        fiber100g: Double? = nil,
        sugars100g: Double? = nil,
        proteins100g: Double? = nil,
        salt100g: Double? = nil,
        scaledQuantity: Int? = nil,
        scaledEnergyKcal: Double? = nil,
        scaledFat: Double? = nil,
        scaledSaturatedFat: Double? = nil,
        scaledCarbohydrates: Double? = nil,
        scaledFiber: Double? = nil,
        scaledSugars: Double? = nil,
        scaledProteins: Double? = nil,
        scaledSalt: Double? = nil
    ) {
        self.code = code
        self.productName = productName
        self.brands = brands
        self.quantity = quantity
        self.categories = categories
        self.nutriscoreGrade = nutriscoreGrade
        self.imageUrl = imageUrl
        
        self.energyKcal100g = energyKcal100g
        self.fat100g = fat100g
        self.saturatedFat100g = saturatedFat100g
        self.carbohydrates100g = carbohydrates100g
        self.fiber100g = fiber100g
        self.sugars100g = sugars100g
        self.proteins100g = proteins100g
        self.salt100g = salt100g
        
        self.scaledQuantity = scaledQuantity
        self.scaledEnergyKcal = scaledEnergyKcal
        self.scaledFat = scaledFat
        self.scaledSaturatedFat = scaledSaturatedFat
        self.scaledCarbohydrates = scaledCarbohydrates
        self.scaledFiber = scaledFiber
        self.scaledSugars = scaledSugars
        self.scaledProteins = scaledProteins
        self.scaledSalt = scaledSalt
    }
    
}
