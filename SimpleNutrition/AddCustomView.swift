import SwiftUI
import SwiftData

struct AddCustomView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Query var savedFoods: [SavedFoodsSingleton]

    let currentDay: Tag
    @Binding var tabState: TabSelection

    @State private var productName     = ""
    @State private var brands          = ""
    @State private var category        = ""
    @State private var quantity        = ""
    @State private var nutriscoreGrade = ""
    @State private var calories        = ""
    @State private var carbohydrates   = ""
    @State private var sugar           = ""
    @State private var protein         = ""
    @State private var fat             = ""
    @State private var saturatedFat    = ""
    @State private var fiber           = ""
    @State private var salt            = ""

    @State private var showError   = false
    @State private var errorMessage = ""

    // MARK: - Body
    var body: some View {
        List {
            // Page header
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Eigene Produkte")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.snInk2)
                        Text("Mahlzeit")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(Color.snInk)
                    }
                    Spacer()
                    saveButton
                }
                .listRowBackground(Color.snBackground)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 6, bottom: 4, trailing: 6))
            }

            // Product info section
            Section {
                snRow(label: "Name", placeholder: "z.B. Apfel", text: $productName)
                snRow(label: "Marke", placeholder: "optional", text: $brands)
                snRow(label: "Kategorie", placeholder: "optional", text: $category)
                snRow(label: "Packungsmenge", placeholder: "z.B. 100g", text: $quantity)
                snRow(label: "Nutri-Score", placeholder: "A – E", text: $nutriscoreGrade)
            } header: {
                sectionLabel("PRODUKT")
            }

            // Nutrition section
            Section {
                snNumberRow(label: "Kalorien",        placeholder: "kcal",  text: $calories)
                snNumberRow(label: "Kohlenhydrate",    placeholder: "g",     text: $carbohydrates)
                snNumberRow(label: "davon Zucker",     placeholder: "g",     text: $sugar)
                snNumberRow(label: "Protein",          placeholder: "g",     text: $protein)
                snNumberRow(label: "Fett",             placeholder: "g",     text: $fat)
                snNumberRow(label: "davon gesättigt",  placeholder: "g",     text: $saturatedFat)
                snNumberRow(label: "Ballaststoffe",    placeholder: "g",     text: $fiber)
                snNumberRow(label: "Salz",             placeholder: "g",     text: $salt)
            } header: {
                sectionLabel("NÄHRWERTE PRO 100 g")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.snBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Fehler", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    // MARK: - Row helpers
    private func snRow(label: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(Color.snInk)
            Spacer()
            TextField(placeholder, text: text)
                .multilineTextAlignment(.trailing)
                .font(.system(size: 14))
                .foregroundStyle(Color.snInk2)
        }
        .padding(.vertical, 2)
        .listRowBackground(Color.snCard)
    }

    private func snNumberRow(label: String, placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundStyle(label.hasPrefix("davon") ? Color.snInk3 : Color.snInk)
            Spacer()
            TextField(placeholder, text: text)
                .multilineTextAlignment(.trailing)
                .keyboardType(.numberPad)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Color.snInk2)
        }
        .padding(.vertical, 2)
        .listRowBackground(Color.snCard)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Color.snInk2)
            .kerning(0.6)
            .textCase(nil)
    }

    private var saveButton: some View {
        Button {
            do {
                try addCustomFood()
            } catch AddCustomViewExceptions.emptyProductName {
                errorMessage = "Produktname darf nicht leer sein"; showError = true
            } catch AddCustomViewExceptions.emptyQuantity {
                errorMessage = "Menge darf nicht leer sein"; showError = true
            } catch AddCustomViewExceptions.emptyNutriscoreGrade {
                errorMessage = "Nutri-Score muss angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptyCalories {
                errorMessage = "Kalorien müssen angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptyCarbohydrates {
                errorMessage = "Kohlenhydrate müssen angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptySugar {
                errorMessage = "Zucker muss angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptyProtein {
                errorMessage = "Protein muss angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptyFat {
                errorMessage = "Fett muss angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptySaturatedFat {
                errorMessage = "Gesättigte Fette müssen angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptyFiber {
                errorMessage = "Ballaststoffe müssen angegeben werden"; showError = true
            } catch AddCustomViewExceptions.emptySalt {
                errorMessage = "Salz muss angegeben werden"; showError = true
            } catch {
                errorMessage = "Unbekannter Fehler"; showError = true
            }
        } label: {
            Text("Speichern")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(Color.snPrimary)
                .clipShape(Capsule())
        }
    }

    // MARK: - Logic (unchanged)
    private func addCustomFood() throws {
        guard !productName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyProductName }
        guard !quantity.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyQuantity }
        guard !nutriscoreGrade.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyNutriscoreGrade }
        guard !calories.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyCalories }
        guard !carbohydrates.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyCarbohydrates }
        guard !sugar.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptySugar }
        guard !protein.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyProtein }
        guard !fat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyFat }
        guard !saturatedFat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptySaturatedFat }
        guard !fiber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptyFiber }
        guard !salt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { throw AddCustomViewExceptions.emptySalt }

        let food = Food(
            code: UUID().uuidString,
            productName: productName,
            brands: brands,
            quantity: quantity,
            categories: category,
            nutriscoreGrade: nutriscoreGrade,
            energyKcal100g:   Double(calories),
            fat100g:          Double(fat),
            saturatedFat100g: Double(saturatedFat),
            carbohydrates100g: Double(carbohydrates),
            fiber100g:        Double(fiber),
            sugars100g:       Double(sugar),
            proteins100g:     Double(protein),
            salt100g:         Double(salt)
        )
        savedFoods.first?.addSavedFood(food: food)
        tabState = .CurrentDay
    }
}
