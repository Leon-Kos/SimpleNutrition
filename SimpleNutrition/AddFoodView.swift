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
    
    
    let day: Tag
    let food: Food
    
    @State private var quantityText: String = "100"
    
    private var quantity: Double {
        Double(quantityText) ?? 100
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
                TextField("Gramm eingeben", text: $quantityText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 5)
            }
        }
        .navigationTitle(food.productName ?? "Unbekannt")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let add_food = Food(
                        code: food.code,
                        productName: food.productName,
                        brands: food.brands,
                        quantity: quantityText + "g",
                        categories: food.categories,
                        nutriscoreGrade: food.nutriscoreGrade,
                        imageUrl: food.imageUrl,
                        
                        energyKcal100g: scaled(food.energyKcal100g),
                        fat100g: scaled(food.fat100g),
                        saturatedFat100g: scaled(food.saturatedFat100g),
                        carbohydrates100g: scaled(food.carbohydrates100g),
                        fiber100g: scaled(food.fiber100g),
                        sugars100g: scaled(food.sugars100g),
                        proteins100g: scaled(food.proteins100g),
                        salt100g: scaled(food.salt100g)
                    )
                    addFood(food: add_food)
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
        return value * quantity / 100.0
    }

    private func addFood(food: Food) {
        context.insert(food)
        day.addFood(food: food)
        do {
            try context.save()
        } catch {
            print("Fehler in addFood()")
        }
    }
    
}

//#Preview {
//    AddFoodView()
//}
