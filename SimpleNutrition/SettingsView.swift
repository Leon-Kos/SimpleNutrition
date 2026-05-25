import SwiftUI

struct SettingsView: View {

    @Binding var tabState: TabSelection
    let currentDay: Tag

    @State private var kohlenhydrate: Double = 0
    @State private var protein: Double       = 0
    @State private var fett: Double          = 0
    @State private var kalorien: Double      = 0

    // MARK: - Body
    var body: some View {
        List {
            // Page header
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Tagesziele anpassen")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color.snInk2)
                        Text("Ziele")
                            .font(.system(size: 32, weight: .semibold))
                            .foregroundStyle(Color.snInk)
                    }
                    Spacer()
                }
                .listRowBackground(Color.snBackground)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 6, bottom: 4, trailing: 6))
            }

            // Calorie display card
            Section {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("KALORIENZIEL")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color.snInk3)
                            .kerning(0.8)
                        HStack(alignment: .lastTextBaseline, spacing: 6) {
                            Text(String(format: "%.0f", kalorien))
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundStyle(Color.snInk)
                            Text("kcal")
                                .font(.system(size: 14))
                                .foregroundStyle(Color.snInk3)
                        }
                    }
                    Spacer()
                    VStack(alignment: .center, spacing: 2) {
                        ZStack {
                            Circle()
                                .stroke(Color.snTint, lineWidth: 5)
                                .frame(width: 52, height: 52)
                            Circle()
                                .trim(from: 0, to: min(1.0, CGFloat(currentDay.progress_kcal)))
                                .stroke(Color.snPrimary, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                                .rotationEffect(.degrees(-90))
                                .frame(width: 52, height: 52)
                        }
                        Text("heute")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.snInk3)
                    }
                }
                .padding(.vertical, 6)
                .listRowBackground(Color.snCard)
                .listRowSeparator(.hidden)
            } header: {
                sectionLabel("KALORIEN")
            }

            // Macro sliders
            Section {
                macroSliderRow(
                    label: "Kohlenhydrate",
                    value: $kohlenhydrate,
                    color: .snCarbs,
                    unit: "g"
                )
                macroSliderRow(
                    label: "Protein",
                    value: $protein,
                    color: .snProtein,
                    unit: "g"
                )
                macroSliderRow(
                    label: "Fett",
                    value: $fett,
                    color: .snFat,
                    unit: "g"
                )
            } header: {
                sectionLabel("MAKRONÄHRSTOFFE")
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.snBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            kohlenhydrate = currentDay.maxKohlenhydrate
            protein       = currentDay.maxProtein
            fett          = currentDay.maxFett
            kalorien      = currentDay.maxKalorien
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    tabState = .CurrentDay
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(Color.snInk2)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveSettings()
                } label: {
                    Text("Speichern")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.snPrimary)
                }
            }
        }
    }

    // MARK: - Macro slider row
    private func macroSliderRow(label: String, value: Binding<Double>, color: Color, unit: String) -> some View {
        VStack(spacing: 8) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(color).frame(width: 8, height: 8)
                    Text(label)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                }
                Spacer()
                HStack(spacing: 2) {
                    Text(String(format: "%.0f", value.wrappedValue))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                    Text(unit)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.snInk3)
                }
            }
            TextField("", value: value, format: .number)
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.snTint)
                .clipShape(RoundedRectangle(cornerRadius: 11))
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.snInk)
                .onChange(of: value.wrappedValue) {
                    kalorien = calculateKalorien()
                }
        }
        .padding(.vertical, 6)
        .listRowBackground(Color.snCard)
        .listRowSeparator(.hidden)
    }

    private func sectionLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(Color.snInk2)
            .kerning(0.6)
            .textCase(nil)
    }

    // MARK: - Logic (unchanged)
    private func saveSettings() {
        currentDay.adjustNutrients(maxK: Int(kohlenhydrate), maxP: Int(protein), maxF: Int(fett))
        tabState = .CurrentDay
    }

    private func calculateKalorien() -> Double {
        kohlenhydrate * 4 + protein * 4 + fett * 9
    }
}

#Preview {
    @Previewable var currentDay = Tag(maxK: 250, maxP: 140, maxF: 80)
    @Previewable @State var tabState: TabSelection = .Settings
    SettingsView(tabState: $tabState, currentDay: currentDay)
}
