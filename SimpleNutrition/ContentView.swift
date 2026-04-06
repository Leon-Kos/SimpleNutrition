//
//  ContentView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData
import Foundation

enum TabSelection: Hashable {
    case CurrentDay, Log, Scan, Erstellen, Settings
}

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query(sort: \Tag.date, order: .reverse) var days: [Tag]
    @Query var savedFoods: [SavedFoodsSingleton]
    
    @State private var savedFoodsArray = []
    
    @State var currentDay: Tag = Tag(maxK: 0, maxP: 0, maxF: 0)
    
    
    @State private var tabState: TabSelection = .CurrentDay
    
    // Properties needed for BarcodeScanner
    @State private var scannedCode: String? = nil
    @State private var selectedFood: FoodResponse?
    @State private var showDetail = false
    @State private var errorMessage: String?
    
    // Properties to trigger
    @State private var showAddFood: Bool = false
    @State private var showCreateFood: Bool = false
    
    var body: some View {
        TabView(selection: $tabState) {
            NavigationStack {
                CurrentDayView(currentDay: currentDay)
            }
            .tabItem {
                Label("", systemImage: "chart.pie")
            }
            .tag(TabSelection.CurrentDay)
            NavigationStack {
                LogView(days: days)
            }
            .tabItem {
                Label("", systemImage: "long.text.page.and.pencil.fill")
            }
            .tag(TabSelection.Log)
            NavigationStack {
                BarcodeScannerView(scannedCode: $scannedCode)
                    .navigationDestination(isPresented: $showDetail) {
                        if let response = selectedFood {
                            let food = Food(code: response.code,
                                            productName: response.productName,
                                            brands: response.brands,
                                            quantity: response.quantity,
                                            categories: response.categories,
                                            nutriscoreGrade: response.nutriscoreGrade,
                                            imageUrl: response.imageUrl,
                                            energyKcal100g: response.energyKcal100g,
                                            fat100g: response.fat100g,
                                            saturatedFat100g: response.saturatedFat100g,
                                            carbohydrates100g: response.carbohydrates100g,
                                            fiber100g: response.fiber100g,
                                            sugars100g: response.sugars100g,
                                            proteins100g: response.proteins100g,
                                            salt100g: response.salt100g,
                                            scaledQuantity: Int(response.quantity ?? "0") ?? 0,
                                            scaledEnergyKcal: Double(response.energyKcal100g ?? 0.0),
                                            scaledFat: Double(response.fat100g ?? 0.0),
                                            scaledSaturatedFat: Double(response.saturatedFat100g ?? 0.0),
                                            scaledCarbohydrates: Double(response.carbohydrates100g ?? 0.0),
                                            scaledFiber: Double(response.fiber100g ?? 0.0),
                                            scaledSugars: Double(response.sugars100g ?? 0.0),
                                            scaledProteins: Double(response.proteins100g ?? 0.0),
                                            scaledSalt: Double(response.salt100g ?? 0.0),
                                            
                            )
                            AddFoodView(day: currentDay, food: food)
                        }
                        
                    }
                    .onChange(of: scannedCode) {
                        guard let code = scannedCode, !code.isEmpty else { return }
                        FoodRequest.fetchProduct(code: code) { result in
                            DispatchQueue.main.async {
                                switch result {
                                case .success(let food):
                                    self.selectedFood = food
                                    self.showDetail = true
                                case .failure(let error):
                                    errorMessage = error.localizedDescription
                                }
                            }
                        }
                        showDetail = false
                    }
            }
            .tabItem {
                Label("", systemImage: "barcode")
            }
            .tag(TabSelection.Scan)
            NavigationStack {
                AddCustomView(currentDay: currentDay, tabState: $tabState)
            }
            .tabItem {
                Label("", systemImage: "plus")
            }
            .tag(TabSelection.Erstellen)
            
            
            NavigationStack {
                SettingsView(tabState: $tabState, currentDay: currentDay)
            }
            .tabItem {
                Label("", systemImage: "person")
            }
            .tag(TabSelection.Settings)
        }
        .onAppear {
            fetchDay()
            fetchSavedFoods()
        }
        
    }
    
    private func fetchDay() {
        let tag = Tag(maxK: 0.0, maxP: 0.0, maxF: 0.0)
        if (tag.getDateHeader() != days.first?.getDateHeader()) {
            tag.maxKalorien = days.first?.maxKalorien ?? 0.0
            tag.maxKohlenhydrate = days.first?.maxKohlenhydrate ?? 0.0
            tag.maxProtein = days.first?.maxProtein ?? 0.0
            tag.maxFett = days.first?.maxFett ?? 0.0
            currentDay = tag
            if(!days.contains(where: { $0.id == tag.id } )) {
                context.insert(currentDay)
            }
            do {
                try context.save()
            } catch {
                print("Error in saving a new day")
            }
        } else {
            currentDay = days.first ?? currentDay
        }
    }
    
    private func fetchSavedFoods() {
        if let first = savedFoods.first {
            savedFoodsArray = first.getSavedFoods()
        } else {
            let first = SavedFoodsSingleton()
            context.insert(first)
            do {
                try context.save()
            } catch {
                print("Problem in fetchSavedFoods()")
            }
            savedFoodsArray = first.getSavedFoods()
        }
        
    }
    
}

#Preview {
    ContentView()
}
