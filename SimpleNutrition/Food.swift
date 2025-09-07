import Foundation
import SwiftData

@Model
class Food: Identifiable {
    var id: String { code }  // Identifiable für SwiftUI Listen

    var code: String
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

    // Initializer
    init(
        code: String,
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
        salt100g: Double? = nil
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
    }
    
    func getKalorien() -> Int {
        let cal = (self.carbohydrates100g ?? 0) * 4.0 + (self.proteins100g ?? 0) * 4.0 + (self.fat100g ?? 0) * 9.0 + (self.fiber100g ?? 0) * 2.0
        return Int(cal)
    }
}
