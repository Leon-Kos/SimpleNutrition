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
}
