//
//  FoodAPI.swift
//  SimpleNutrition
//
//

import Foundation

class FoodRequest {
    static func fetchProduct(code: String, completion: @escaping (Result<FoodResponse, Error>) -> Void) {
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(code).json"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let food = try JSONDecoder().decode(FoodResponse.self, from: data)
                completion(.success(food))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
        
    static func searchProducts(keyword: String, completion: @escaping (Result<[FoodResponse], Error>) -> Void) {
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? keyword
        let urlString = "https://world.openfoodfacts.org/api/v2/search?search_terms=\(query)&page_size=20&fields=code,product_name,brands,quantity,categories,nutriscore_grade,image_url,energy-kcal_100g,fat_100g,saturated-fat_100g,carbohydrates_100g,fiber_100g,sugars_100g,proteins_100g,salt_100g"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            guard let data = data else { return }
            
            do {
                struct SearchResponse: Decodable {
                    let products: [FoodResponse]
                }
                let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(result.products))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

}
