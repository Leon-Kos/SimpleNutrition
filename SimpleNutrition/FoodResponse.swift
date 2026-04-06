//
//  FoodResponse.swift
//  SimpleNutrition
//
//
import Foundation

struct FoodResponse: Decodable, Identifiable {
    var id = UUID()
    let status: Int
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

    // MARK: - Custom Decoder
    enum CodingKeys: String, CodingKey {
        case status
        case code
        case product
    }

    enum ProductKeys: String, CodingKey {
        case productName = "product_name"
        case brands, quantity, categories
        case nutriscoreGrade = "nutriscore_grade"
        case imageUrl = "image_url"
        case nutriments
    }

    enum NutrimentsKeys: String, CodingKey {
        case energyKcal100g = "energy-kcal_100g"
        case fat100g = "fat_100g"
        case saturatedFat100g = "saturated-fat_100g"
        case carbohydrates100g = "carbohydrates_100g"
        case fiber100g = "fiber_100g"
        case sugars100g = "sugars_100g"
        case proteins100g = "proteins_100g"
        case salt100g = "salt_100g"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Int.self, forKey: .status)
        code = try container.decode(String.self, forKey: .code)

        let product = try? container.nestedContainer(keyedBy: ProductKeys.self, forKey: .product)
        productName = try product?.decodeIfPresent(String.self, forKey: .productName)
        brands = try product?.decodeIfPresent(String.self, forKey: .brands)
        quantity = try product?.decodeIfPresent(String.self, forKey: .quantity)
        categories = try product?.decodeIfPresent(String.self, forKey: .categories)
        nutriscoreGrade = try product?.decodeIfPresent(String.self, forKey: .nutriscoreGrade)
        imageUrl = try product?.decodeIfPresent(String.self, forKey: .imageUrl)

        let nutriments = try? product?.nestedContainer(keyedBy: NutrimentsKeys.self, forKey: .nutriments)
        energyKcal100g = try nutriments?.decodeIfPresent(Double.self, forKey: .energyKcal100g)
        fat100g = try nutriments?.decodeIfPresent(Double.self, forKey: .fat100g)
        saturatedFat100g = try nutriments?.decodeIfPresent(Double.self, forKey: .saturatedFat100g)
        carbohydrates100g = try nutriments?.decodeIfPresent(Double.self, forKey: .carbohydrates100g)
        fiber100g = try? nutriments?.decodeIfPresent(Double.self, forKey: .fiber100g)
        sugars100g = try nutriments?.decodeIfPresent(Double.self, forKey: .sugars100g)
        proteins100g = try nutriments?.decodeIfPresent(Double.self, forKey: .proteins100g)
        salt100g = try nutriments?.decodeIfPresent(Double.self, forKey: .salt100g)
    }
    
    init(
            status: Int = 1,
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
            self.status = status
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
}
