//
//  SearchResponse.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 07.09.25.
//

//
//  SearchResponse.swift
//  SimpleNutrition
//

import Foundation

struct SearchResponse: Decodable {
    let products: [SearchFood]

    struct SearchFood: Decodable, Identifiable {
        var id: String { code }
        let code: String
        let productName: String?
        let brands: String?
        let quantity: String?
        let categories: String?
        let nutriscoreGrade: String?
        let imageUrl: String?

        let energyKcal100g: Double?
        let fat100g: Double?
        let saturatedFat100g: Double?
        let carbohydrates100g: Double?
        let fiber100g: Double?
        let sugars100g: Double?
        let proteins100g: Double?
        let salt100g: Double?

        enum CodingKeys: String, CodingKey {
            case code
            case productName = "product_name"
            case brands
            case quantity
            case categories
            case nutriscoreGrade = "nutriscore_grade"
            case imageUrl = "image_url"
            case energyKcal100g = "energy-kcal_100g"
            case fat100g = "fat_100g"
            case saturatedFat100g = "saturated-fat_100g"
            case carbohydrates100g = "carbohydrates_100g"
            case fiber100g = "fiber_100g"
            case sugars100g = "sugars_100g"
            case proteins100g = "proteins_100g"
            case salt100g = "salt_100g"
        }
    }
}
