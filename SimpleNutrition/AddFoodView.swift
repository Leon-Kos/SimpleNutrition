import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Query var foods: [Food]
    @Query var savedFoods: [SavedFoodsSingleton]

    let day: Tag
    let food: Food

    @State private var quantity: Int = 100

    init(day: Tag, food: Food) {
        self.day  = day
        self.food = food
        _quantity = State(initialValue: Int(parseQuantity(food.quantity)))
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                macroHighlightCard
                nutritionDetailCard
                quantityCard
            }
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.snBackground)
        .navigationTitle(food.productName ?? "Unbekannt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    addFood()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.snPrimary)
                }
            }
        }
    }

    // MARK: - Macro highlight card
    private var macroHighlightCard: some View {
        VStack(spacing: 14) {
            Text("NÄHRWERTE  ·  \(quantity) g / ml")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.snInk2)
                .kerning(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack(spacing: 0) {
                macroHighlight(label: "Kalorien",    value: "\(Int(scaled(food.energyKcal100g) ?? 0)) kcal", color: .snPrimary)
                Spacer()
                macroHighlight(label: "Protein",     value: String(format: "%.1f g", scaled(food.proteins100g) ?? 0),       color: .snProtein)
                Spacer()
                macroHighlight(label: "Kohlenhydr.", value: String(format: "%.1f g", scaled(food.carbohydrates100g) ?? 0),   color: .snCarbs)
                Spacer()
                macroHighlight(label: "Fett",        value: String(format: "%.1f g", scaled(food.fat100g) ?? 0),             color: .snFat)
            }
        }
        .padding(18)
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.snInk.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private func macroHighlight(label: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(value)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(Color.snInk)
                .multilineTextAlignment(.center)
            Text(label)
                .font(.system(size: 10))
                .foregroundStyle(Color.snInk3)
        }
    }

    // MARK: - Nutrition detail card
    private var nutritionDetailCard: some View {
        VStack(spacing: 0) {
            Text("NÄHRWERTE PRO 100 g / ml")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.snInk2)
                .kerning(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 12)

            if let kcal = scaled(food.energyKcal100g) {
                detailRow(label: "Kalorien",          value: "\(Int(kcal)) kcal",                            isLast: false)
            }
            if let fat = scaled(food.fat100g) {
                detailRow(label: "Fett",              value: String(format: "%.1f g", fat),                 isLast: false)
            }
            if let satFat = scaled(food.saturatedFat100g) {
                detailRow(label: "– gesättigte Fette", value: String(format: "%.1f g", satFat),             isLast: false)
            }
            if let carbs = scaled(food.carbohydrates100g) {
                detailRow(label: "Kohlenhydrate",      value: String(format: "%.1f g", carbs),              isLast: false)
            }
            if let sugar = scaled(food.sugars100g) {
                detailRow(label: "– Zucker",           value: String(format: "%.1f g", sugar),              isLast: false)
            }
            if let fiber = scaled(food.fiber100g) {
                detailRow(label: "Ballaststoffe",      value: String(format: "%.1f g", fiber),              isLast: false)
            }
            if let protein = scaled(food.proteins100g) {
                detailRow(label: "Protein",            value: String(format: "%.1f g", protein),            isLast: false)
            }
            if let salt = scaled(food.salt100g) {
                detailRow(label: "Salz",               value: String(format: "%.2f g", salt),               isLast: true)
            }
        }
        .padding(18)
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.snInk.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private func detailRow(label: String, value: String, isLast: Bool) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(label.hasPrefix("–") ? Color.snInk3 : Color.snInk)
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color.snInk2)
        }
        .padding(.vertical, 10)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(Color.snInk.opacity(0.07))
                    .frame(height: 0.5)
            }
        }
    }

    // MARK: - Quantity card
    private var quantityCard: some View {
        VStack(spacing: 12) {
            Text("MENGE")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.snInk2)
                .kerning(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                TextField("Gramm eingeben", value: $quantity, format: .number)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                    .textFieldStyle(.plain)
                Spacer()
                Text("g / ml")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.snInk2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.snTint)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(18)
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.snInk.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Logic (unchanged)
    private func scaled(_ value: Double?) -> Double? {
        guard let value else { return 0.0 }
        return value * Double(quantity) / 100.0
    }

    private func addFood() {
        let name = String(food.productName?.prefix(25) ?? "Unbekannt")
        let food = Food(
            code: food.code,
            productName: name,
            brands: food.brands,
            quantity: food.quantity,
            categories: limitCategorySize(categories: food.categories ?? ""),
            nutriscoreGrade: food.nutriscoreGrade,
            imageUrl: food.imageUrl,
            energyKcal100g:    food.energyKcal100g,
            fat100g:           food.fat100g,
            saturatedFat100g:  food.saturatedFat100g,
            carbohydrates100g: food.carbohydrates100g,
            fiber100g:         food.fiber100g,
            sugars100g:        food.sugars100g,
            proteins100g:      food.proteins100g,
            salt100g:          food.salt100g,
            scaledQuantity:    quantity,
            scaledEnergyKcal:  scaled(food.energyKcal100g)    ?? 0.0,
            scaledFat:         scaled(food.fat100g)           ?? 0.0,
            scaledSaturatedFat: scaled(food.saturatedFat100g) ?? 0.0,
            scaledCarbohydrates: scaled(food.carbohydrates100g) ?? 0.0,
            scaledFiber:       scaled(food.fiber100g)         ?? 0.0,
            scaledSugars:      scaled(food.sugars100g)        ?? 0.0,
            scaledProteins:    scaled(food.proteins100g)      ?? 0.0,
            scaledSalt:        scaled(food.salt100g)          ?? 0.0
        )
        context.insert(food)
        day.addFood(food: food)
        if !savedFoods.first!.getSavedFoods().contains(where: { $0.code == food.code }) {
            savedFoods.first!.addSavedFood(food: food)
        }
        do {
            try context.save()
        } catch {
            print("Fehler in addFood()")
        }
    }

    private func parseQuantity(_ quantity: String?) -> Double {
        guard let quantity else { return 100 }
        let pattern = "[0-9]+(\\.[0-9]+)?"
        if let range = quantity.range(of: pattern, options: .regularExpression) {
            let numberString = String(quantity[range])
            if let number = Double(numberString) {
                let lowercased = quantity.lowercased()
                if lowercased.contains("ml") || lowercased.contains("g") { return number }
                else if lowercased.contains("l") { return number * 1000 }
                return number
            }
        }
        return 100
    }

    private func limitCategorySize(categories: String) -> String {
        if categories.isEmpty { return "" }
        return categories.components(separatedBy: ",").first ?? ""
    }
}
