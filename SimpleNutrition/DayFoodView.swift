//
//  FoodView.swift
//  SimpleNutrition
//
//

import SwiftUI


struct DayFoodView: View {
    
    let food: Food
    
    @State private var overview: [CustomTuple<String, String>] = []
    @State private var nutrients: [CustomTuple<String, Double>] = []
        
    var body: some View {
        List {
            Section("Allgemein") {
                ForEach(overview, id: \.id) { item in
                    HStack {
                        Text(item.s)
                            .font(.headline)
                        Spacer()
                        Text(item.t)
                            .font(.headline)
                    }
                }
            }
            Section("Nährwerte") {
                ForEach(nutrients, id: \.id) { item in
                    if item.s == "Kalorien" {
                        HStack {
                            Text(item.s)
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.1f", item.t) + "kcal")
                                .font(.headline)
                        }
                    } else {
                        HStack {
                            Text(item.s)
                                .font(.headline)
                            Spacer()
                            Text(String(format: "%.1f", item.t) + "g")
                                .font(.headline)
                        }
                    }
                    
                }
            }
        }
        .navigationTitle(food.productName ?? "Unbekannt")
        .onAppear {
            computeOverview()
            computeNutrients()
        }
    }
    
    private func computeOverview() {
        overview.append(CustomTuple(s: "Code", t: food.code))
        overview.append(CustomTuple(s: "Name", t: food.productName ?? "Unbekannt"))
        overview.append(CustomTuple(s: "Hersteller", t: food.brands ?? "Unbekannt"))
        overview.append(CustomTuple(s: "Menge", t: food.quantity ?? "0"))
        //overview.append(CustomTuple(s: "Kategorie", t: food.categories ?? "Unbekannt"))
    }
    
    private func computeNutrients() {
        nutrients.append(CustomTuple(s: "Kalorien", t: food.energyKcal100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Kohlenhydrate", t: food.carbohydrates100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Zucker", t: food.sugars100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Protein", t: food.proteins100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Fett", t: food.fat100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Gesättigte Fettsäuren", t: food.saturatedFat100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Ballaststoffe", t: food.fiber100g ?? 0.0))
        nutrients.append(CustomTuple(s: "Salz", t: food.salt100g ?? 0.0))
    }
    
}

//#Preview {
//    FoodView()
//}
