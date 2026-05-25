import Foundation
import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) var context
    let days: [Tag]

    var body: some View {
        List {
            Section {
                dayEntries
            } header: {
                logPageHeader
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.snBackground)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Section header (page title + week card + section label)
    @ViewBuilder
    private var logPageHeader: some View {
        VStack(spacing: 0) {
            // Page title
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Ernährungsprotokoll")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Color.snInk2)
                    Text("Logbuch")
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundStyle(Color.snInk)
                }
                Spacer()
            }
            .padding(.horizontal, 6)
            .padding(.top, 8)
            .padding(.bottom, 4)

            // Week summary card
            if !days.isEmpty {
                weekSummaryCard
                    .padding(.top, 14)
            }

            // Section label
            HStack {
                Text("EINTRÄGE")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                    .kerning(0.5)
                Spacer()
                Text("\(days.count) Tage")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.snInk3)
            }
            .padding(.horizontal, 6)
            .padding(.top, 22)
            .padding(.bottom, 10)
        }
        .background(Color.snBackground)
        .textCase(nil)
    }

    // MARK: - Week Summary Card
    private var weekSummaryCard: some View {
        let slice   = Array(days.prefix(7))
        let n       = Double(slice.count).clamped(to: 1...Double.infinity)
        let avgKcal = Int(slice.map(\.kalorien).reduce(0, +) / n)
        let avgP    = Int(slice.map(\.protein).reduce(0, +) / n)
        let avgC    = Int(slice.map(\.kohlenhydrate).reduce(0, +) / n)
        let avgF    = Int(slice.map(\.fett).reduce(0, +) / n)

        return ZStack(alignment: .topTrailing) {
            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 140, height: 140)
                .offset(x: 30, y: -30)

            VStack(alignment: .leading, spacing: 0) {
                Text("WOCHENDURCHSCHNITT")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .kerning(0.8)

                HStack(alignment: .lastTextBaseline, spacing: 8) {
                    Text("\(avgKcal)")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("kcal / Tag")
                        .font(.system(size: 13))
                        .foregroundStyle(.white.opacity(0.7))
                }
                .padding(.top, 6)

                HStack(spacing: 18) {
                    macroAvgLabel(prefix: "Ø P", value: "\(avgP) g")
                    macroAvgLabel(prefix: "K",   value: "\(avgC) g")
                    macroAvgLabel(prefix: "F",   value: "\(avgF) g")
                }
                .padding(.top, 12)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            LinearGradient(
                colors: [Color.snPrimary, Color.snDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func macroAvgLabel(prefix: String, value: String) -> some View {
        HStack(spacing: 4) {
            Text(prefix).foregroundStyle(.white.opacity(0.6))
            Text(value).bold()
        }
        .font(.system(size: 12))
        .foregroundStyle(.white)
    }

    // MARK: - Day entries
    @ViewBuilder
    private var dayEntries: some View {
        if days.isEmpty {
            VStack(spacing: 10) {
                Image(systemName: "text.book.closed")
                    .font(.system(size: 30))
                    .foregroundStyle(Color.snInk3)
                Text("Noch keine Einträge")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.snInk2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .listRowBackground(Color.snCard)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets())
        } else {
            ForEach(days) { day in
                let isLast = days.last?.id == day.id
                NavigationLink {
                    DayView(currentDay: day, dateHeader: day.getDateHeader())
                } label: {
                    dayRow(day: day, isLast: isLast)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.snCard)
                .swipeActions(edge: .trailing) {
                    Button(role: .destructive) {
                        delete_day(day: day)
                    } label: {
                        Label("Löschen", systemImage: "trash")
                    }
                }
            }
        }
    }

    private func dayRow(day: Tag, isLast: Bool) -> some View {
        HStack(spacing: 14) {
            // Date badge
            VStack(spacing: 1) {
                let parts = day.getDateAsString().components(separatedBy: ".")
                Text(parts.first ?? "–")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.snPrimary)
            }
            .frame(width: 48, height: 48)
            .background(Color.snTint)
            .clipShape(RoundedRectangle(cornerRadius: 13))

            VStack(alignment: .leading, spacing: 4) {
                Text(day.getDateHeader().localizedCapitalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                    .lineLimit(1)
                HStack(spacing: 8) {
                    macroChip(color: .snProtein, text: "P \(Int(day.protein))g")
                    macroChip(color: .snCarbs,   text: "K \(Int(day.kohlenhydrate))g")
                    macroChip(color: .snFat,     text: "F \(Int(day.fett))g")
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text("\(Int(day.kalorien))")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.snInk)
                if progressBoundCheck(day: day) {
                    Text("Ziel")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(Color.snPrimary)
                } else {
                    Text("+\(Int(day.kalorien) - Int(day.maxKalorien)) kcal")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Color.snWarn)
                }
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.snInk3)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
        .overlay(alignment: .bottom) {
            if !isLast {
                Rectangle()
                    .fill(Color.snInk.opacity(0.07))
                    .frame(height: 0.5)
                    .padding(.leading, 78)
            }
        }
    }

    private func macroChip(color: Color, text: String) -> some View {
        HStack(spacing: 3) {
            Circle().fill(color).frame(width: 5, height: 5)
            Text(text)
        }
        .font(.system(size: 11))
        .foregroundStyle(Color.snInk3)
    }

    // MARK: - Logic (unchanged)
    func delete_day(day: Tag) {
        context.delete(day)
        do {
            try context.save()
        } catch {
            print("Fehler in delete_day()")
        }
    }

    private func progressBoundCheck(day: Tag) -> Bool {
        Int(day.kalorien) <= Int(day.maxKalorien)
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
