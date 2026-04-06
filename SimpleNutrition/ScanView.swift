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
    
    @State private var errorMessage: String?
    @State private var foods: [Food] = []
    
    let day: Tag
    
    //let day = Tag(maxK: 150, maxP: 150, maxF: 80)
    
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
                            .background(Color.accentColor)
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
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                }

                
                
                
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
                        salt100g: response.salt100g,
                        scaledQuantity: Int(response.quantity!) ?? 0,
                        scaledEnergyKcal: Double(response.energyKcal100g ?? 0.0),
                        scaledFat: Double(response.fat100g ?? 0.0),
                        scaledSaturatedFat: Double(response.saturatedFat100g ?? 0.0),
                        scaledCarbohydrates: Double(response.carbohydrates100g ?? 0.0),
                        scaledFiber: Double(response.fiber100g ?? 0.0),
                        scaledSugars: Double(response.sugars100g ?? 0.0),
                        scaledProteins: Double(response.proteins100g ?? 0.0),
                        scaledSalt: Double(response.salt100g ?? 0.0),
                    
                    )
                    AddFoodView(day: day, food: food)
                }
            }
            .onAppear {
                //fetchFood()
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
}

//#Preview {
//    ScanView()
//}



// Barcode Search Action
//Button(action: {
//    FoodRequest.fetchProduct(code: barcode) { result in
//        DispatchQueue.main.async {
//            switch result {
//            case .success(let food):
//                self.selectedFood = food
//                self.showDetail = true
//            case .failure(let error):
//                errorMessage = error.localizedDescription
//            }
//        }
//    }
//}) {
//    Image(systemName: "magnifyingglass")
//        .frame(maxWidth: .infinity)
//        .padding()
//        .background(Color.accentColor)
//        .foregroundColor(.white)
//        .cornerRadius(10)
//        .padding(.horizontal)
//}
