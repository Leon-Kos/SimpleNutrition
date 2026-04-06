//
//  SettingsView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData

struct EditDayView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @Query var days: [Tag]

    @State private var kohlenhydrate: Int = 0
    @State private var protein: Int = 0
    @State private var fett: Int = 0
    
    let day: Tag
    
    var body: some View {
        VStack {
            List {
                Section("Makronährstoffe") {
                    VStack {
                        Text("Kohlenhydrate")
                            .font(.headline)
                        TextField("Kohlenhydrate", value: $kohlenhydrate, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                        
                        Text("Protein")
                            .font(.headline)
                        TextField("Protein", value: $protein, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                        
                        Text("Fett")
                            .font(.headline)
                        TextField("Fett", value: $fett, format: .number)
                            .keyboardType(.numberPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.vertical, 5)
                        
                    }
                }
                

            }
            Button {
                day.adjustNutrients(maxK: kohlenhydrate, maxP: protein, maxF: fett)
                dismiss()
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
            kohlenhydrate = Int(day.maxKohlenhydrate)
            protein = Int(day.maxProtein)
            fett = Int(day.maxFett)
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
