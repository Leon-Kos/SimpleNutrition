import SwiftUI
import SwiftData

struct AddSavedFoodView: View {
    @Environment(\.modelContext) var context
    @Query var savedFoods: [SavedFoodsSingleton]

    let currentDay: Tag
    @State private var searchText = ""

    var body: some View {
        List {
            if searchResults.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 30))
                        .foregroundStyle(Color.snInk3)
                    Text("Keine Ergebnisse")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.snInk2)
                    if !searchText.isEmpty {
                        Text("Versuche einen anderen Suchbegriff.")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.snInk3)
                    } else {
                        Text("Scanne oder erstelle ein Produkt, um es hier zu sehen.")
                            .font(.system(size: 13))
                            .foregroundStyle(Color.snInk3)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .listRowBackground(Color.snCard)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
            } else {
                ForEach(searchResults) { food in
                    let isLast = searchResults.last?.id == food.id
                    NavigationLink {
                        AddFoodView(day: currentDay, food: food)
                    } label: {
                        savedFoodRow(food: food, isLast: isLast)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.snCard)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.snBackground)
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Produkt suchen …"
        )
        .navigationTitle("Gespeicherte Lebensmittel")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func savedFoodRow(food: Food, isLast: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 11)
                    .fill(Color.snTint)
                    .frame(width: 40, height: 40)
                Image(systemName: "fork.knife")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.snPrimary)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(food.productName ?? "Unbekannt")
                    .font(.system(size: 14.5, weight: .medium))
                    .foregroundStyle(Color.snInk)
                    .lineLimit(1)
                Text("\(Int(food.energyKcal100g ?? 0)) kcal / 100g")
                    .font(.system(size: 11.5))
                    .foregroundStyle(Color.snInk3)
            }
            Spacer()
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
                    .padding(.leading, 68)
            }
        }
    }

    var searchResults: [Food] {
        if searchText.isEmpty {
            return savedFoods.first?.getSavedFoods() ?? []
        } else {
            return (savedFoods.first?.getSavedFoods() ?? []).filter {
                $0.productName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
    }
}

#Preview {
    @Previewable var currentDay = Tag(maxK: 250, maxP: 140, maxF: 80)
    AddSavedFoodView(currentDay: currentDay)
}
