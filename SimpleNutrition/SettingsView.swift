//
//  SettingsView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) var context
    @Query var days: [Tag]
    @Query(sort: \NutritionData.date, order: .reverse) var nutritionData: [NutritionData]

    @State private var kohlenhydrate: Int = 0
    @State private var protein: Int = 0
    @State private var fett: Int = 0
    
    var body: some View {
        VStack {
            List {
                Section("Makronährstoffe") {
                    HStack {
                        VStack {
                            Text("Kohlenhyd.")
                                .font(.title3)
                            Picker("Kohlenhydrate", selection: $kohlenhydrate) { ForEach(0...500, id: \.self) { Text("\($0) g") } }
                                .pickerStyle(.wheel)
                                .frame(height: 150)
                        }
                        VStack {
                            Text("Protein")
                                .font(.title3)
                            Picker("Protein", selection: $protein) { ForEach(0...500, id: \.self) { Text("\($0) g") } }
                                .pickerStyle(.wheel)
                                .frame(height: 150)
                        }
                        VStack {
                            Text("Fett")
                                .font(.title3)
                            Picker("Fett", selection: $fett) { ForEach(0...500, id: \.self) { Text("\($0) g") } }
                                .pickerStyle(.wheel)
                                .frame(height: 150)
                        }
                    }
                }

            }
            Button {
                print(kohlenhydrate)
                print(protein)
                print(fett)
                let new_data = NutritionData(kohlenhydrate: Double(kohlenhydrate), protein: Double(protein), fett: Double(fett))
                context.insert(new_data)
                do {
                    try context.save()
                } catch {
                    print("Fehler beim Speichern von NutrtionData: \(error)")
                }
                
            } label: {
                Text("Hinzufügen")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .onAppear {
            for data in nutritionData {
                if dataDateString(date: data.date) == dayString() {
                    kohlenhydrate = Int(data.kohlenhydrate)
                    protein = Int(data.protein)
                    fett = Int(data.fett)
                    break
                }
            }
        }
        
    }
    
    private func dataDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func dayString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

}

//#Preview {
//    SettingsView()
//}
