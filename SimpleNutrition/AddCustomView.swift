import SwiftUI
import SwiftData

struct AddCustomView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var savedFoods: [SavedFoodsSingleton]
    
    //let day = Tag(maxK: 120, maxP: 150, maxF: 80)
    let currentDay: Tag
    @Binding var tabState: TabSelection
    
    @State private var productName = ""
    @State private var brands = ""
    @State private var category = ""
    @State private var quantity = ""
    @State private var nutriscoreGrade = ""
    @State private var calories = ""
    @State private var carbohydrates = ""
    @State private var sugar = ""
    @State private var protein = ""
    @State private var fat = ""
    @State private var saturatedFat = ""
    @State private var fiber = ""
    @State private var salt = ""
    
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section("Produkt") {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("z.B. Apfel", text: $productName)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Marke")
                        Spacer()
                        TextField("optional", text: $brands)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Kategorie")
                        Spacer()
                        TextField("optional", text: $category)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Packungsmenge")
                        Spacer()
                        TextField("z.B. 100g", text: $quantity)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numbersAndPunctuation)
                    }
                    
                    HStack {
                        Text("Nutri-Score")
                        Spacer()
                        TextField("A–E", text: $nutriscoreGrade)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Nährwerte pro 100g") {
                    HStack {
                        Text("Kalorien")
                        Spacer()
                        TextField("kcal", text: $calories)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Kohlenhydrate")
                        Spacer()
                        TextField("g", text: $carbohydrates)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("davon Zucker")
                        Spacer()
                        TextField("g", text: $sugar)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Protein")
                        Spacer()
                        TextField("g", text: $protein)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Fett")
                        Spacer()
                        TextField("g", text: $fat)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("davon gesättigt")
                        Spacer()
                        TextField("g", text: $saturatedFat)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Ballaststoffe")
                        Spacer()
                        TextField("g", text: $fiber)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                    
                    HStack {
                        Text("Salz")
                        Spacer()
                        TextField("g", text: $salt)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.numberPad)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Eigenes Produkt")
            //.navigationBarTitleDisplayMode(.inline)

            .alert("Fehler", isPresented: $showError, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(errorMessage)
            })
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        do {
                            try addCustomFood()
                        } catch AddCustomViewExceptions.emptyProductName {
                            errorMessage = "Produktname darf nicht leer sein"
                            showError = true
                        } catch AddCustomViewExceptions.emptyQuantity {
                            errorMessage = "Menge darf nicht leer sein"
                            showError = true
                        } catch AddCustomViewExceptions.emptyNutriscoreGrade {
                            errorMessage = "Nutri-Score muss angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptyCalories {
                            errorMessage = "Kalorien müssen angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptyCarbohydrates {
                            errorMessage = "Kohlenhydrate müssen angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptySugar {
                            errorMessage = "Zucker muss angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptyProtein {
                            errorMessage = "Protein muss angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptyFat {
                            errorMessage = "Fett muss angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptySaturatedFat {
                            errorMessage = "Gesättigte Fette müssen angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptyFiber {
                            errorMessage = "Ballaststoffe müssen angegeben werden"
                            showError = true
                        } catch AddCustomViewExceptions.emptySalt {
                            errorMessage = "Salz muss angegeben werden"
                            showError = true
                        } catch {
                            errorMessage = "Unbekannter Fehler"
                            showError = true
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        
    }
    
    private func addCustomFood() throws {
        guard !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyProductName
        }
        guard !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyQuantity
        }
        guard !nutriscoreGrade.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyNutriscoreGrade
        }
        guard !calories.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyCalories
        }
        guard !carbohydrates.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyCarbohydrates
        }
        guard !sugar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptySugar
        }
        guard !protein.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyProtein
        }
        guard !fat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyFat
        }
        guard !saturatedFat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptySaturatedFat
        }
        guard !fiber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptyFiber
        }
        guard !salt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AddCustomViewExceptions.emptySalt
        }
        
        let food = Food(
            code: UUID().uuidString,
            productName: productName,
            brands: brands,
            quantity: quantity,
            categories: category,
            nutriscoreGrade: nutriscoreGrade,
            energyKcal100g: Double(calories),
            fat100g: Double(fat),
            saturatedFat100g: Double(saturatedFat),
            carbohydrates100g: Double(carbohydrates),
            fiber100g: Double(fiber),
            sugars100g: Double(sugar),
            proteins100g: Double(protein),
            salt100g: Double(salt)
        )
        savedFoods.first?.addSavedFood(food: food)
        tabState = .CurrentDay
    }
    
}

//#Preview {
//    AddCustomView()
//}
