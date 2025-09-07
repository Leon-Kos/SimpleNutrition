//
//  ScanView.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 03.09.25.
//

import SwiftUI
import SwiftData
import VisionKit
import AVFoundation

struct ScanView: View {
    @Environment(\.modelContext) var context
    @Query var foodsArray: [Food]
    
    @State private var errorMessage: String?
    @State private var foods: [Food] = []
    
    let day: Tag
    
    // Fetch Food
    @State private var barcode = ""
    @State private var selectedFood: FoodResponse?
    @State private var showDetail = false

    
    
    
    @State private var showScanner = false
    @State private var scannedCode: String? = nil
    
    

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Scan Barcode")
                    .font(.headline)
                    .padding(.leading)
                TextField("Barcode eingeben", text: $barcode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                HStack {
                    Button(action: {
                        FoodRequest.fetchProduct(code: barcode) { result in
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
                    }) {
                        Image(systemName: "magnifyingglass")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    Button {
                        showScanner = true
                    } label: {
                        Image(systemName: "barcode.viewfinder")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }
                
                Text("Füge schon bekanntes hinzu")
                    .font(.headline)
                    .padding(.leading)
                    .padding(.top)
                List {
                    ForEach(foods) { item in
                        NavigationLink {
                            AddFoodView(day: day, food: item)
                        } label: {
                            Text(item.productName ?? "Unbekannt")
                        }
                    }
                }
                .listStyle(.plain)
                
                
                
                Spacer()
            }
            .navigationTitle("Hinzufügen")
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
                        salt100g: response.salt100g)
                    AddFoodView(day: day, food: food)
                }
            }
            .onAppear {
                fetchFood()
            }
            .sheet(isPresented: $showScanner) {
                BarcodeScannerView(scannedCode: $scannedCode)
                    .onDisappear {
                        FoodRequest.fetchProduct(code: scannedCode ?? "") { result in
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
                    }
            }
        }
    }
    
    private func fetchFood() {
        var new_foods: [Food] = []
        for food in foodsArray {
            if new_foods.contains(where: { $0.productName ?? "" == food.productName }) {
                continue
            } else {
                new_foods.append(food)
            }
        }
        foods = new_foods
    }
}

//#Preview {
//    ScanView(day: Tag())
//}
