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
    )

    let barWidth     = UIScreen.main.bounds.width * 0.52
    let rectHeight   = UIScreen.main.bounds.height / 12
    let elementsWidth = UIScreen.main.bounds.width * 0.9

    @State private var initialAmountNumber = 0
    @State private var amountNumber = 0
    @State private var amountPercentage = 1.0

    @State private var kh_percentage = 0.0
    @State private var p_percentage  = 0.0
    @State private var f_percentage  = 0.0

    @State private var unit = ""
    @State private var showAlert = false

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                productHeaderCard
                nutrientsCard
                quantityCard
            }
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
        .background(Color.snBackground)
        .navigationTitle(food.productName ?? "Unbekannt")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    updateFood()
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.snPrimary)
                }
            }
        }
        .onAppear {
            placeHolderFood    = food.copy()
            amountNumber       = food.scaledQuantity ?? 0
            initialAmountNumber = amountNumber
            kh_percentage = getMacroPercentage(amount: food.scaledCarbohydrates ?? 0.0)
            p_percentage  = getMacroPercentage(amount: food.scaledProteins ?? 0.0)
            f_percentage  = getMacroPercentage(amount: food.scaledFat ?? 0.0)
            unit = (food.quantity ?? "").filter { !$0.isNumber }
        }
    }

    // MARK: - Product header card
    private var productHeaderCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.snTint)
                        .frame(width: 56, height: 56)
                    Image(systemName: "fork.knife")
                        .font(.system(size: 24))
                        .foregroundStyle(Color.snPrimary)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(food.productName ?? "Unbekannt")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                    Text(food.brands ?? "Unbekannte Marke")
                        .font(.system(size: 13))
                        .foregroundStyle(Color.snInk2)
                    Text(food.categories ?? "–")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.snInk3)
                        .lineLimit(1)
                }
                Spacer()
                VStack(spacing: 2) {
                    Text("Nutri")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Color.snInk3)
                    ZStack {
                        RoundedRectangle(cornerRadius: 9)
                            .fill(Color.nutriScore(nutri: placeHolderFood.nutriscoreGrade ?? ""))
                            .frame(width: 38, height: 38)
                        let grade = (placeHolderFood.nutriscoreGrade ?? "").uppercased()
                        Text(["A","B","C","D","E"].contains(grade) ? grade : "–")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)
            .padding(.bottom, 12)

            Rectangle().fill(Color.snInk.opacity(0.07)).frame(height: 0.5)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("KALORIEN")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.snInk3)
                        .kerning(0.8)
                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        Text("\(Int(placeHolderFood.scaledEnergyKcal ?? 0))")
                            .font(.system(size: 30, weight: .semibold))
                            .foregroundStyle(Color.snInk)
                        Text("kcal  ·  \(Int(placeHolderFood.energyKcal100g ?? 0)) kcal/100g")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.snInk3)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.snInk.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Nutrients card
    private var nutrientsCard: some View {
        VStack(spacing: 14) {
            Text("NÄHRWERTE  für \(amountNumber)\(unit.isEmpty ? "g" : unit)")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.snInk2)
                .kerning(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)

            macroSection(label: "Kohlenhydrate", value: placeHolderFood.scaledCarbohydrates, percentage: kh_percentage, color: .snCarbs)
            subRow(label: "davon Zucker", value: placeHolderFood.scaledSugars ?? 0)

            snDivider

            macroSection(label: "Protein", value: placeHolderFood.scaledProteins, percentage: p_percentage, color: .snProtein)

            snDivider

            macroSection(label: "Fett", value: placeHolderFood.scaledFat, percentage: f_percentage, color: .snFat)
            subRow(label: "davon gesättigt", value: placeHolderFood.scaledSaturatedFat ?? 0)

            snDivider

            HStack(spacing: 0) {
                compactStat(label: "Ballaststoffe", value: String(format: "%.1f", placeHolderFood.scaledFiber ?? 0) + (unit.isEmpty ? "g" : unit))
                Spacer()
                compactStat(label: "Salz", value: String(format: "%.2f", placeHolderFood.scaledSalt ?? 0) + (unit.isEmpty ? "g" : unit))
                Spacer()
            }
        }
        .padding(18)
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: Color.snInk.opacity(0.06), radius: 16, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    private func macroSection(label: String, value: Double?, percentage: Double, color: Color) -> some View {
        VStack(spacing: 6) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(color).frame(width: 8, height: 8)
                    Text(label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                }
                Spacer()
                Text(String(format: "%.1f", value ?? 0) + (unit.isEmpty ? "g" : unit))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.snInk)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(Color.snInk.opacity(0.07))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 99)
                        .fill(color)
                        .frame(width: max(0, geo.size.width * CGFloat(min(percentage, 1.0))), height: 6)
                }
            }
            .frame(height: 6)
        }
    }

    private func subRow(label: String, value: Double) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12))
                .foregroundStyle(Color.snInk3)
                .padding(.leading, 14)
            Spacer()
            Text(String(format: "%.1f", value) + (unit.isEmpty ? "g" : unit))
                .font(.system(size: 12))
                .foregroundStyle(Color.snInk3)
        }
    }

    private func compactStat(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label).font(.system(size: 12)).foregroundStyle(Color.snInk2)
            Text(value).font(.system(size: 15, weight: .semibold)).foregroundStyle(Color.snInk)
        }
    }

    private var snDivider: some View {
        Rectangle().fill(Color.snInk.opacity(0.07)).frame(height: 0.5)
    }

    // MARK: - Quantity card
    private var quantityCard: some View {
        VStack(spacing: 12) {
            Text("MENGE ÄNDERN")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(Color.snInk2)
                .kerning(0.6)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                TextField("Menge eingeben", value: $amountNumber, format: .number)
                    .keyboardType(.numberPad)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                    .onChange(of: amountNumber, updateData)
                Spacer()
                Text(unit.isEmpty ? "g" : unit)
                    .font(.system(size: 16, weight: .medium))
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
    private func updateFood() {
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

    private func getMacroPercentage(amount: Double) -> Double {
        amount / Double(amountNumber)
    }

    private func updateData() {
        let newAmount_realtive = Double(amountNumber) / 100
        placeHolderFood.scaledQuantity       = amountNumber
        placeHolderFood.scaledEnergyKcal     = (placeHolderFood.energyKcal100g     ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledFat            = (placeHolderFood.fat100g            ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSaturatedFat   = (placeHolderFood.saturatedFat100g   ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledCarbohydrates  = (placeHolderFood.carbohydrates100g  ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledFiber          = (placeHolderFood.fiber100g          ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSugars         = (placeHolderFood.sugars100g         ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledProteins       = (placeHolderFood.proteins100g       ?? 0.0) * newAmount_realtive
        placeHolderFood.scaledSalt           = (placeHolderFood.salt100g           ?? 0.0) * newAmount_realtive
    }
}
