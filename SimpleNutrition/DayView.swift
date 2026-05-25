import SwiftUI
import SwiftData

struct DayView: View {
    @Environment(\.modelContext) var context
    @Query var foods: [Food]

    let currentDay: Tag
    let dateHeader: String
    @State var progress_kcal = 0.0
    @State var progress_kh   = 0.0
    @State var progress_p    = 0.0
    @State var progress_f    = 0.0
    @State var progress_w    = 0.0

    @State private var addFood = false

    // MARK: - Body
    var body: some View {
        List {
            Section {
                foodSection
            } header: {
                pageHeaderAndHeroCard
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.snBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $addFood) {
            AddSavedFoodView(currentDay: currentDay)
        }
        .onAppear { getProgress() }
    }

    // MARK: - Section header (page title + hero card + meals label)
    @ViewBuilder
    private var pageHeaderAndHeroCard: some View {
        VStack(spacing: 0) {
            // Page title
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(currentDay.getDateAsString())
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.snInk2)
                    Text(Calendar.current.isDateInToday(currentDay.date) ? "Heute" : dateHeader.localizedCapitalized)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 4)

            // Hero card
            heroCard
                .padding(.top, 16)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .padding(.horizontal, 20)
            

            // Meals section label
            HStack {
                Text("HEUTIGE MAHLZEITEN")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                    .kerning(0.5)
                Spacer()
                Button { addFood = true } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.snPrimary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 10)
        }
        .background(Color.snBackground)
        .textCase(nil)
    }

    // MARK: - Hero Card
    private var heroCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 16) {
                kcalRing
                macroBars
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 18)
            .padding(.top, 20)
            .padding(.bottom, 16)

            Rectangle()
                .fill(Color.snInk.opacity(0.07))
                .frame(height: 0.5)

            HStack(spacing: 0) {
                Spacer()
                miniStat(label: "Kalorien",   value: "\(Int(currentDay.kalorien))",         unit: "kcal")
                Spacer()
                //Rectangle().fill(Color.snInk.opacity(0.07)).frame(width: 0.5, height: 28)
                //Spacer()
//                miniStat(label: "Wasser",     value: "\(Int(currentDay.wasser))",            unit: "ml")
//                Spacer()
                //Rectangle().fill(Color.snInk.opacity(0.07)).frame(width: 0.5, height: 28)
                //Spacer()
                miniStat(label: "Mahlzeiten", value: "\(currentDay.getTracked().count)",      unit: "heute")
                Spacer()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 14)
        }
        .background(Color.snCard)
        .clipShape(RoundedRectangle(cornerRadius: 26))
        .shadow(color: Color.snInk.opacity(0.08), radius: 18, x: 0, y: 4)
        //.padding(.horizontal, 20)
    }

    private var kcalRing: some View {
        let remaining = Int(currentDay.maxKalorien) - Int(currentDay.kalorien)
        return ZStack {
            Circle()
                .stroke(Color.snTint, lineWidth: 11)
                .frame(width: 128, height: 128)
            Circle()
                .trim(from: 0, to: progress_kcal)
                .stroke(
                    progress_kcal > 1.0 ? Color.snWarn : Color.snPrimary,
                    style: StrokeStyle(lineWidth: 11, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 128, height: 128)
                .animation(.easeInOut(duration: 0.6), value: progress_kcal)
            VStack(spacing: 1) {
                Text("verbleibend")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.snInk2)
                Text("\(remaining)")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                Text("von \(Int(currentDay.maxKalorien)) kcal")
                    .font(.system(size: 9.5))
                    .foregroundStyle(Color.snInk3)
            }
        }
    }

    private var macroBars: some View {
        VStack(spacing: 11) {
            macroBar(label: "Protein",       value: currentDay.protein,       goal: currentDay.maxProtein,       progress: progress_p,  color: .snProtein)
            macroBar(label: "Kohlenhydrate", value: currentDay.kohlenhydrate, goal: currentDay.maxKohlenhydrate, progress: progress_kh, color: .snCarbs)
            macroBar(label: "Fett",          value: currentDay.fett,          goal: currentDay.maxFett,          progress: progress_f,  color: .snFat)
        }
    }

    private func macroBar(label: String, value: Double, goal: Double, progress: Double, color: Color) -> some View {
        VStack(spacing: 5) {
            HStack {
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.snInk2)
                Spacer()
                HStack(spacing: 0) {
                    Text("\(Int(value))")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                    Text(" / \(Int(goal))g")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.snInk3)
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 99)
                        .fill(Color.snInk.opacity(0.07))
                        .frame(height: 7)
                    RoundedRectangle(cornerRadius: 99)
                        .fill(color)
                        .frame(width: max(0, geo.size.width * CGFloat(min(1.0, progress))), height: 7)
                        .animation(.easeInOut(duration: 0.6), value: progress)
                }
            }
            .frame(height: 7)
        }
    }

    private func miniStat(label: String, value: String, unit: String) -> some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.snInk2)
            Text(value)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.snInk)
            Text(unit)
                .font(.system(size: 10))
                .foregroundStyle(Color.snInk3)
        }
    }

    // MARK: - Food section rows
    @ViewBuilder
    private var foodSection: some View {
        if currentDay.getTracked().isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "fork.knife")
                    .font(.system(size: 30))
                    .foregroundStyle(Color.snInk3)
                Text("Noch keine Mahlzeiten")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.snInk2)
                Text("Tippe auf \"+\" um etwas hinzuzufügen.")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.snInk3)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 36)
            .listRowBackground(Color.snCard)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        } else {
            ForEach(currentDay.getTracked()) { food in
                let isLast = currentDay.getTracked().last?.id == food.id
                NavigationLink {
                    FoodView(day: currentDay, food: food)
                } label: {
                    foodRow(food: food, isLast: isLast)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.snCard)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete_food(food: food)
                        getProgress()
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                }
            }
        }
    }

    private func foodRow(food: Food, isLast: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.snTint)
                    .frame(width: 44, height: 44)
                Image(systemName: "fork.knife")
                    .font(.system(size: 17))
                    .foregroundStyle(Color.snPrimary)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(food.productName ?? "Unbekannt")
                    .font(.system(size: 14.5, weight: .medium))
                    .foregroundStyle(Color.snInk)
                    .lineLimit(1)
                HStack(spacing: 5) {
                    Text("\(food.scaledQuantity ?? 0)g")
                        .foregroundStyle(Color.snInk3)
                    Text("·").foregroundStyle(Color.snInk3)
                    Text("P \(Int(food.scaledProteins ?? 0))")
                        .foregroundStyle(Color.snProtein)
                        .fontWeight(.medium)
                    Text("K \(Int(food.scaledCarbohydrates ?? 0))")
                        .foregroundStyle(Color.snCarbs)
                        .fontWeight(.medium)
                    Text("F \(Int(food.scaledFat ?? 0))")
                        .foregroundStyle(Color.snFat)
                        .fontWeight(.medium)
                }
                .font(.system(size: 11.5))
            }
            Spacer(minLength: 4)
            VStack(alignment: .trailing, spacing: 1) {
                Text("\(Int(food.scaledEnergyKcal ?? 0))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                Text("kcal")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.snInk3)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.snInk3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(Color.snInk.opacity(0.07))
                    .frame(height: 0.5)
                    .padding(.leading, 72)
            }
        }
    }

    // MARK: - Logic (unchanged)
    private func delete_food(food: Food) {
        currentDay.removeFood(food: food)
        do {
            try context.save()
        } catch {
            print("Error in delete_Food() in Overview")
        }
    }

    private func getProgress() {
        let progress  = currentDay.getProgress()
        progress_kcal = progress["kcal"] ?? 0.0
        progress_kh   = progress["kh"]   ?? 0.0
        progress_p    = progress["p"]    ?? 0.0
        progress_f    = progress["f"]    ?? 0.0
        progress_w    = progress["w"]    ?? 0.0
    }
}
