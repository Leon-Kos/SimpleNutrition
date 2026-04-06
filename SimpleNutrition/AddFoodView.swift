//
//  AddFoodView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData


struct AddFoodView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var foods: [Food]
    @Query var savedFoods: [SavedFoodsSingleton]
    
    
    let day: Tag
    let food: Food
    
    @State private var quantity: Int = 100
    
    init(day: Tag, food: Food) {
        self.day = day
        self.food = food
        _quantity = State(initialValue: Int(parseQuantity(food.quantity)))
    }

    
    var body: some View {
        List {
            Section("Nährwerte pro 100g/ml") {
                if let kcal = scaled(food.energyKcal100g) {
                    HStack {
                        Text("Kalorien")
                        Spacer()
                        Text("\(Int(kcal)) kcal")
                            .foregroundColor(.secondary)
                    }
                }
                if let fat = scaled(food.fat100g) {
                    HStack {
                        Text("Fett")
                        Spacer()
                        Text("\(fat, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let satFat = scaled(food.saturatedFat100g) {
                    HStack {
                        Text("– gesättigte Fette")
                        Spacer()
                        Text("\(satFat, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let carbs = scaled(food.carbohydrates100g) {
                    HStack {
                        Text("Kohlenhydrate")
                        Spacer()
                        Text("\(carbs, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let sugar = scaled(food.sugars100g) {
                    HStack {
                        Text("– Zucker")
                        Spacer()
                        Text("\(sugar, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let fiber = scaled(food.fiber100g) {
                    HStack {
                        Text("Ballaststoffe")
                        Spacer()
                        Text("\(fiber, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let protein = scaled(food.proteins100g) {
                    HStack {
                        Text("Protein")
                        Spacer()
                        Text("\(protein, specifier: "%.1f") g")
                            .foregroundColor(.secondary)
                    }
                }
                
                if let salt = scaled(food.salt100g) {
                    HStack {
                        Text("Salz")
                        Spacer()
                        Text("\(salt, specifier: "%.2f") g")
                            .foregroundColor(.secondary)
                    }
                }
            }
            Section("Menge in g/ml") {
                TextField("Gramm eingeben", value: $quantity, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
            }
        }
        .navigationTitle(food.productName ?? "Unbekannt")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    //saveAndDismiss()
                    addFood()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func scaled(_ value: Double?) -> Double? {
        guard let value else { return 0.0 }
        return value * Double(quantity) / 100.0
    }

    private func addFood(/*food: Food*/) {
        let name = String(food.productName?.prefix(25) ?? "Unbekannt")
        let food = Food(
            code: food.code,
            productName: name,
            brands: food.brands,
            quantity: food.quantity,
            categories: limitCategorySize(categories: food.categories ?? ""),
            nutriscoreGrade: food.nutriscoreGrade,
            imageUrl: food.imageUrl,
            
            energyKcal100g: food.energyKcal100g,
            fat100g: food.fat100g,
            saturatedFat100g: food.saturatedFat100g,
            carbohydrates100g: food.carbohydrates100g,
            fiber100g: food.fiber100g,
            sugars100g: food.sugars100g,
            proteins100g: food.proteins100g,
            salt100g: food.salt100g,
            
            scaledQuantity: quantity,
            scaledEnergyKcal: scaled(food.energyKcal100g) ?? 0.0,
            scaledFat: scaled(food.fat100g) ?? 0.0,
            scaledSaturatedFat: scaled(food.saturatedFat100g) ?? 0.0,
            scaledCarbohydrates: scaled(food.carbohydrates100g) ?? 0.0,
            scaledFiber: scaled(food.fiber100g) ?? 0.0,
            scaledSugars: scaled(food.sugars100g) ?? 0.0,
            scaledProteins: scaled(food.proteins100g) ?? 0.0,
            scaledSalt: scaled(food.salt100g) ?? 0.0
            
        )
        context.insert(food)
        day.addFood(food: food)
        if (!savedFoods.first!.getSavedFoods().contains(where: { $0.code == food.code })) {
            savedFoods.first!.addSavedFood(food: food)
        }
        do {
            try context.save()
        } catch {
            print("Fehler in addFood()")
        }
    }
    
    private func parseQuantity(_ quantity: String?) -> Double {
        guard let quantity else { return 100 } // Fallback, wenn nil
        
        // Zahl extrahieren (z. B. "200 g" -> "200")
        let pattern = "[0-9]+(\\.[0-9]+)?"
        if let range = quantity.range(of: pattern, options: .regularExpression) {
            let numberString = String(quantity[range])
            if let number = Double(numberString) {
                // Einheit prüfen
                let lowercased = quantity.lowercased()
                if lowercased.contains("ml") || lowercased.contains("g") {
                    return number
                } else if lowercased.contains("l") {
                    return number * 1000 // 1 L = 1000 ml
                }
                return number
            }
        }
        return 100 // Fallback, wenn keine Zahl gefunden
    }
    
    private func limitCategorySize(categories: String) -> String {
        if categories == "" { return "" }
        else {
            let separated = categories.components(separatedBy: ",")
            return separated.first ?? ""
        }
    }
    
}

//#Preview {
//    AddFoodView()
//}
