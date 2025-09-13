//
//  DayView.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 02.09.25.
//

import SwiftUI
import SwiftData

struct DayView: View {
    @Environment(\.modelContext) var context
    @Query var foods: [Food]
    
    let day: Tag
    
    
    var body: some View {
        List {
            Section("Übersicht") {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Kalorien")
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
                        Text("Ballaststoffe")
                            .font(.callout)
                            .bold()
                        Text("Salz")
                            .font(.callout)
                            .bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("\(Int(day.kalorien)) / \(self.getMaxKalorien())kcal")
                            .font(.title3)
                            .bold()
                        Text("\(Int(day.kohlenhydrate)) / \(Int(day.maxKohlenhydrate))g")
                            .font(.callout)
                            .bold()
                        Text("\(Int(day.protein)) / \(Int(day.maxProtein))g")
                            .font(.callout)
                            .bold()
                        Text("\(Int(day.fett)) / \(Int(day.maxFett))g")
                            .font(.callout)
                            .bold()
                        Text("\(Int(day.fiber))g")
                            .font(.callout)
                            .bold()
                        Text("\(Int(day.salt))g")
                            .font(.callout)
                            .bold()
                    }
                }
            }
            Section("Nahrungsmittel") {
                ForEach(day.getTracked()) { food in
                    NavigationLink {
                        DayFoodView(food: food)
                    } label: {
                        HStack {
                            Text(food.productName ?? "Unbekannt")
                            Spacer()
                            Text("\(food.getKalorien()) kcal")
                        }
                    }
                }
                .onDelete(perform: delete_food)
            }
            .navigationTitle(day.getDateAsString())
            .onAppear {

            }
        }
        
        
    }
    
    private func delete_food(at offsets: IndexSet) {
        day.removeFood(at: offsets)
    }
    
    private func getMaxKalorien() -> Int {
        let kalorien = Int(day.maxKohlenhydrate * 4 + day.maxProtein * 4 + day.maxFett * 9)
        return kalorien
    }
        
}

//#Preview {
//    DayView()
//}
