//
//  FoodView.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 02.09.25.
//

import SwiftUI


struct DayFoodView: View {
    
    let food: Food
    
    var body: some View {
        List {
            Section("Allgemeine Informationen") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Kalorien")
                            .font(.title3)
                            .bold()
                        Text("Anzahl")
                            .font(.title3)
                            .bold()
                        Text("Kohlenhydrate")
                            .font(.callout)
                            .bold()
                        Text("Protein")
                            .font(.callout)
                            .bold()
                        Text("Fett")
                            .font(.callout)
                            .bold()
                    }
                    Spacer()
                    VStack {
                        Text("\(food.getKalorien())")
                            .font(.title3)
                            .bold()
                        Text("\(food.quantity ?? "0")")
                            .font(.title3)
                            .bold()
                        Text("\(Int(food.carbohydrates100g ?? 0.0))")
                            .font(.callout)
                            .bold()
                        Text("\(Int(food.proteins100g ?? 0.0))")
                            .font(.callout)
                            .bold()
                        Text("\(Int(food.fat100g ?? 0.0))")
                            .font(.callout)
                            .bold()
                    }
                }
            }
        }
        .navigationTitle(food.productName ?? "Unbekannt")
    }
}

//#Preview {
//    FoodView()
//}
