//
//  AddSavedFood.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 04.04.26.
//

import SwiftUI
import SwiftData

struct AddSavedFoodView: View {
    @Environment(\.modelContext) var context
    @Query var savedFoods: [SavedFoodsSingleton]
    
    let currentDay: Tag
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(/*savedFoods.first?.getSavedFoods() ?? []*/searchResults) { food in
                    NavigationLink {
                        AddFoodView(day: currentDay, food: food)
                    } label: {
                        HStack {
                            Text(food.productName ?? "Unbekannt")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Gespeicherte Lebensmittel")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    var searchResults: [Food] {
        if searchText.isEmpty {
            return savedFoods.first!.getSavedFoods()
        } else {
            return savedFoods.first!.getSavedFoods().filter {
                $0.productName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
    
}

#Preview {
    @Previewable var currentDay = Tag(maxK: 250, maxP: 140, maxF: 80)
    AddSavedFoodView(currentDay: currentDay)
}
