//
//  SettingsView.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 05.04.26.
//

import SwiftUI

struct SettingsView: View {
    
    @Binding var tabState: TabSelection
    let currentDay: Tag
    @State private var kohlenhydrate: Double = 0
    @State private var protein: Double = 0
    @State private var fett: Double = 0
    
    @State private var kalorien: Double = 0
    
    var body: some View {
        List {
            Section("Tageziel") {
                HStack {
                    Text("Kalorien")
                    Spacer()
                    Text(String(format: "%.f", kalorien) + " kcal")
                        .bold()
                }
//                HStack {
//                    Text("Wasser")
//                        .foregroundStyle(Color.colorWasser())
//                        .bold()
//                    Spacer()
//                    TextField("", value: $fett, format: .number)
//                        .frame(maxWidth: 250)
//                        .multilineTextAlignment(.trailing)
//                        .keyboardType(.numberPad)
//                        .onChange(of: fett) {
//                            kalorien = calculateKalrorien()
//                        }
//                    Text("mL")
//                        .bold()
//                }
            }
            Section("Makronährstoffe") {
                HStack {
                    Text("Kohlenhydrate")
                        .foregroundStyle(Color.colorKohlenhydrate())
                        .bold()
                    Spacer()
                    TextField("", value: $kohlenhydrate, format: .number)
                        .frame(maxWidth: 250)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: kohlenhydrate) {
                            kalorien = calculateKalrorien()
                        }
                    Text("g")
                        .bold()
                }
                HStack {
                    Text("Protein")
                        .foregroundStyle(Color.colorProtein())
                        .bold()
                    Spacer()
                    TextField("", value: $protein, format: .number)
                        .frame(maxWidth: 250)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: protein) {
                            kalorien = calculateKalrorien()
                        }
                    Text("g")
                        .bold()
                }
                HStack {
                    Text("Fett")
                        .foregroundStyle(Color.colorFett())
                        .bold()
                    Spacer()
                    TextField("", value: $fett, format: .number)
                        .frame(maxWidth: 250)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.numberPad)
                        .onChange(of: fett) {
                            kalorien = calculateKalrorien()
                        }
                    Text("g")
                        .bold()
                }
                
            }
        }
        .listStyle(.plain)
        .listRowSeparator(.hidden)
        .onAppear {
            kohlenhydrate = currentDay.maxKohlenhydrate
            protein = currentDay.maxProtein
            fett = currentDay.maxFett
            kalorien = currentDay.maxKalorien
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    tabState = .CurrentDay
                } label: {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    saveSettings()
                } label: {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
    private func saveSettings() {
        currentDay.adjustNutrients(maxK: Int(kohlenhydrate), maxP: Int(protein), maxF: Int(fett))
        tabState = .CurrentDay
    }
    private func calculateKalrorien() -> Double {
        return kohlenhydrate * 4 + protein * 4 + fett * 9
    }
}

#Preview {
    @Previewable var currentDay = Tag(maxK: 250, maxP: 140, maxF: 80)
    @Previewable @State var tabState: TabSelection = .Settings
    SettingsView(tabState: $tabState, currentDay: currentDay)
}
