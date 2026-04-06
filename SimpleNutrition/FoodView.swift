//
//  FoodView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData

struct FoodView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    
    let day: Tag
    let food: Food
    
    @State private var placeHolderFood: Food = Food(
            code: "737628064502",
            productName: "Griechischer Joghurt",
            brands: "Chobani",
            quantity: "500g",
            categories: "Milchprodukte, Joghurt",
            nutriscoreGrade: "A",
            imageUrl: "https://images.openfoodfacts.org/images/products/737/628/064/502/front.jpg",
            energyKcal100g: 97,
            fat100g: 3.5,
            saturatedFat100g: 2.1,
            carbohydrates100g: 6.2,
            fiber100g: 0.0,
            sugars100g: 4.8,
            proteins100g: 10.2,
            salt100g: 0.1,
            scaledQuantity: 150,
            scaledEnergyKcal: 145.5,
            scaledFat: 5.25,
            scaledSaturatedFat: 3.15,
            scaledCarbohydrates: 9.3,
            scaledFiber: 0.0,
            scaledSugars: 7.2,
            scaledProteins: 15.3,
            scaledSalt: 0.15
        ) // Example Food is overwritten (Used to prevent optional)

    let barWidth = UIScreen.main.bounds.width * 0.52
    let rectHeight = UIScreen.main.bounds.height / 12
    
    let elementsWidth = UIScreen.main.bounds.width * 0.9
    
    @State private var initialAmountNumber = 0
    @State private var amountNumber = 0
    @State private var amountPercentage = 1.0
    
    @State private var kh_percentage = 0.0
    @State private var p_percentage = 0.0
    @State private var f_percentage = 0.0
    
    @State private var unit = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    VStack {
                        // Allgemeine Produkt Infos (Name, Marke und Kategorien)
                        HStack {
                            ZStack {
                                Image(systemName: "fork.knife")
                                    .font(.system(size: UIScreen.main.bounds.width / 12))
                            }
                            VStack(alignment: .leading) {
                                Text(food.productName ?? "Unbekannt")
                                    .font(.title3)
                                    .bold()
                                Text(food.brands ?? "Unbekannte Marke")
                                    .font(.caption)
                                    .bold()
                                Text((food.categories ?? "Unbekannte Kategorie"))/* + " - " + (food.quantity ?? "Unbekannte Menge"))*/
                                    .font(.caption)
                                    .bold()
                            }
                            Spacer()
                        }
                        .padding(.leading, 20)
                        // Kalorien und Nutriscore
                        HStack {
                            ZStack {
                                VStack(alignment: .leading) {
                                    Text("Kalorien".uppercased())
                                        .font(.caption)
                                        .bold()
                                    HStack(alignment: .lastTextBaseline) {
                                        Text("\(Int(placeHolderFood.scaledEnergyKcal ?? 0.0))")
                                            .font(.title)
                                            .bold()
                                        Text("kcal - " + "\(Int(placeHolderFood.energyKcal100g ?? 0.0))kcal / 100g")
                                            .font(.caption)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.leading, 20)
                            Spacer()
                            ZStack {
                                VStack {
                                    HStack {
                                        Text("Nutri-Score".uppercased())
                                            .font(.caption)
                                            .bold()
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .font(.caption)
                                            .frame(
                                                width: UIScreen.main.bounds.width * 0.1,
                                                height: UIScreen.main.bounds.width * 0.1
                                            )
                                            .foregroundStyle(Color.nutriScore(nutri: placeHolderFood.nutriscoreGrade ?? "-"))
                                        Text(["A", "B", "C", "D", "E"].contains((placeHolderFood.nutriscoreGrade ?? "-").uppercased()) ? ((placeHolderFood.nutriscoreGrade ?? "-").uppercased()) : "-")
                                            .font(.title)
                                            .foregroundStyle(.white)
                                            .bold()
                                    }
                                }
                            }
                            .padding(.trailing, 20)
                        }
                        .padding(.bottom, 20)
                        .padding(.top, 10)
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
                
                // Nährwerte
                HStack(alignment: .lastTextBaseline) {
                    Text("Nährwerte")
                        .font(.headline)
                    Text("für \(amountNumber)\(unit)")
                        .font(.caption)
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                ZStack(alignment: .top) {
                    VStack {
                        // Kohlenhydrate
                        HStack {
                            HStack {
                                Text("Kohlenhydrate")
                                    .bold()
                                    .foregroundStyle(Color.colorKohlenhydrate())
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.1f", placeHolderFood.scaledCarbohydrates ?? 0.0) + unit)
                                    .font(.headline)
                                    .bold()
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: UIScreen.main.bounds.width * kh_percentage, height: 5)
                                .foregroundStyle(Color.colorKohlenhydrate())
                                Spacer()
                            Text(String(format: "%.2f", (kh_percentage * 100)) + "%")
                                .font(.caption)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        HStack {
                            Text("davon Zucker")
                                .font(.caption)
                                .bold()
                            Spacer()
                            Text(String(format: "%.1f", placeHolderFood.scaledSugars ?? 0.0) + unit)
                                .font(.caption)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        
                        // Proteine
                        HStack {
                            HStack {
                                Text("Proteine")
                                    .bold()
                                    .foregroundStyle(Color.colorProtein())
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.1f", placeHolderFood.scaledProteins ?? 0.0) + unit)
                                    .font(.headline)
                                    .bold()
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: UIScreen.main.bounds.width * 0.8 * p_percentage, height: 5)
                                .foregroundStyle(Color.colorProtein())
                            Spacer()
                            Text(String(format: "%.2f", (p_percentage * 100)) + "%")
                                .font(.caption)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        
                        // Fett
                        HStack {
                            HStack {
                                Text("Fett")
                                    .bold()
                                    .foregroundStyle(Color.colorFett())
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "%.1f", food.scaledFat ?? 0.0) + unit)
                                    .font(.headline)
                                    .bold()
                            }
                        }
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: UIScreen.main.bounds.width * 0.8 * f_percentage, height: 5)
                                .foregroundStyle(Color.colorFett())
                            Spacer()
                            Text(String(format: "%.2f", (f_percentage * 100)) + "%")
                                .font(.caption)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        HStack {
                            Text("davon gesättigt")
                                .font(.caption)
                                .bold()
                            Spacer()
                            Text(String(format: "%.1f", placeHolderFood.scaledSaturatedFat ?? 0.0) + unit)
                                .font(.caption)
                                .bold()
                        }
                        .padding(.horizontal, 20)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Ballaststoffe")
                                    .font(.caption)
                                    .bold()
                                Text(String(format: "%.1f", placeHolderFood.scaledFiber ?? 0.0) + unit)
                                    .font(.headline)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Salz")
                                    .font(.caption)
                                    .bold()
                                Text(String(format: "%.1f", placeHolderFood.scaledSalt ?? 0.0) + unit)
                                    .font(.headline)
                            }
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }
            
                // Menge ändern
                HStack {
                    Text("Menge ändern")
                        .font(.headline)
                    Spacer()
                }
                .padding(.leading, 20)

                HStack {
                    TextField("Menge eingeben", value: $amountNumber, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: amountNumber, updateData)
//                    Button {
//                        updateData()
//                    } label: {
//                        Image(systemName: "checkmark")
//                            .foregroundStyle(Color.colorMode())
//                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            
            
        }
        .onAppear {
            placeHolderFood = food.copy()
            amountNumber = food.scaledQuantity ?? 0
            initialAmountNumber = amountNumber
            //amountPercentage = getAmountPercentage()
            kh_percentage = getMacroPercentage(amount: food.scaledCarbohydrates ?? 0.0)
            p_percentage = getMacroPercentage(amount: food.scaledProteins ?? 0.0)
            f_percentage = getMacroPercentage(amount: food.scaledFat ?? 0.0)
            unit = (food.quantity ?? "").filter{ !$0.isNumber}
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    updateFood()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    private func updateFood() {
        // Update current food and save it to context, delete old food from context
        let newFood = placeHolderFood
        day.removeFood(food: food)
        day.addFood(food: newFood)
        context.delete(food)
        context.insert(newFood)
        
        do {
            try context.save()
        } catch {
            print("Problem with updateFood()")
        }
        
        
    }

//    private func getAmountPercentage() -> Double {
//        let quantity = (food.quantity ?? "0").filter { $0.isNumber }
//        return Double(food.scaledQuantity) / (Double(quantity) ?? 1.0)
//    }
//    
//    private func updateAmountPercentage() -> Double {
//        let quantity = (food.quantity ?? "0").filter { $0.isNumber }
//        return Double(amountNumber) / (Double(quantity) ?? 1.0)
//    }
    
    private func getMacroPercentage(amount: Double) -> Double {
        let percentage = amount / Double(amountNumber)
        return percentage
    }
    
    private func updateData() {
        let newAmount_realtive = Double(amountNumber) / 100
        placeHolderFood.scaledQuantity = amountNumber
        placeHolderFood.scaledEnergyKcal = (placeHolderFood.energyKcal100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledFat = (placeHolderFood.fat100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSaturatedFat = (placeHolderFood.saturatedFat100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledCarbohydrates = (placeHolderFood.carbohydrates100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledFiber = (placeHolderFood.fiber100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSugars = (placeHolderFood.sugars100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledProteins = (placeHolderFood.proteins100g ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSalt = (placeHolderFood.salt100g ?? 0.0) * newAmount_realtive
    }
    
}

//#Preview {
//    @Previewable @State var testFood: Food = Food(
//        code: "737628064502",
//        productName: "Griechischer Joghurt",
//        brands: "Chobani",
//        quantity: "500g",
//        categories: "Milchprodukte, Joghurt",
//        nutriscoreGrade: "A",
//        imageUrl: "https://images.openfoodfacts.org/images/products/737/628/064/502/front.jpg",
//        energyKcal100g: 97,
//        fat100g: 3.5,
//        saturatedFat100g: 2.1,
//        carbohydrates100g: 6.2,
//        fiber100g: 0.0,
//        sugars100g: 4.8,
//        proteins100g: 10.2,
//        salt100g: 0.1,
//        scaledQuantity: 150,
//        scaledEnergyKcal: 145.5,
//        scaledFat: 5.25,
//        scaledSaturatedFat: 3.15,
//        scaledCarbohydrates: 9.3,
//        scaledFiber: 0.0,
//        scaledSugars: 7.2,
//        scaledProteins: 15.3,
//        scaledSalt: 0.15
//    )
//    //FoodView(food: testFood)
//}

