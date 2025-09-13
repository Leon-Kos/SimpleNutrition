//
//  ContentView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData
import Foundation

struct ContentView: View {
    @Environment(\.modelContext) var context
    @Query var food: [Food]
    @Query(sort: \Tag.date, order: .reverse) var days: [Tag]
    @Query(sort: \NutritionData.date, order: .reverse) var nutritionData: [NutritionData]
    
    var data: NutritionData {
        if let first_data = nutritionData.first {
            return first_data
        } else {
            return NutritionData(kohlenhydrate: 0, protein: 0, fett: 0)
        }
    }
    
    @State var currentDay: Tag = Tag(maxK: 0, maxP: 0, maxF: 0)

    @State var navigationTitle = ""
    
    @State private var wasser: Int = 0
    
    var body: some View {
        NavigationStack {
            List {
                Section("Heute") {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Kalorien")
                                .font(.title3)
                                .bold()
                            Text("Kohlenhydrate")
                                .font(.callout)
                                .bold()
                            Text("Protein")
                                .font(.callout)
                                .bold()
                            Text("Fett")
                                .font(.callout)
                                .bold()
                            Text("Ballaststoffe")
                                .font(.callout)
                                .bold()
                            Text("Salz")
                                .font(.callout)
                                .bold()
                        }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text("\(Int(currentDay.kalorien)) / \(self.getMaxKalorien())kcal")
                                .font(.title3)
                                .bold()
                            Text("\(Int(currentDay.kohlenhydrate)) / \(Int(currentDay.maxKohlenhydrate))g")
                                .font(.callout)
                                .bold()
                            Text("\(Int(currentDay.protein)) / \(Int(currentDay.maxProtein))g")
                                .font(.callout)
                                .bold()
                            Text("\(Int(currentDay.fett)) / \(Int(currentDay.maxFett))g")
                                .font(.callout)
                                .bold()
                            Text("\(Int(currentDay.fiber))g")
                                .font(.callout)
                                .bold()
                            Text("\(Int(currentDay.salt))g")
                                .font(.callout)
                                .bold()
                        }
                    }
                }
                Section("Wasser") {
                    HStack {
                        Text("Wasser")
                            .font(.callout)
                            .bold()
                        Spacer()
                        Text("\(Int(currentDay.water))ml")
                            .font(.callout)
                            .bold()
                        
                    }
                    HStack {
                        TextField("Milliliter", value: $wasser, format: .number)
                            .keyboardType(.numberPad)
                            .padding(.vertical, 5)
                        Button {
                            addWater()
                        } label: {
                            Text("Hinzufügen")
                        }
                    }
                    
                }
                Section("Nahrungsmittel") {
                    ForEach(currentDay.getTracked()) { food in
                        NavigationLink {
                            DayFoodView(food: food)
                        } label: {
                            Text(food.productName ?? "Unbekannt")
                        }
                    }
                    .onDelete(perform: delete_food)
                }
                Section("Logbuch") {
                    ForEach(days) { day in
                        NavigationLink {
                            DayView(day: day)
                        } label: {
                            Text(day.getDateAsString())
                        }
                    }
                    //.onDelete(perform: delete_day)
                }
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        ScanView(day: currentDay)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "person")
                    }
                }
            }
            .onAppear {
                fetchDay()
            }

        }
    }
    
    func delete_food(at offsets: IndexSet) {
        currentDay.removeFood(at: offsets)
    }
    
    func delete_day(day: Tag) {
        context.delete(day)
        do {
            try context.save()
        } catch {
            print("Fehler in delete_day()")
        }
    }

    private func fetchDay() {
        for day in days {
            if day.getDateAsString() == dayString() {
                currentDay = day
                if (currentDay.maxKohlenhydrate != data.kohlenhydrate) || (currentDay.maxProtein != data.protein) || (currentDay.maxFett != data.fett) {
                    currentDay.maxKohlenhydrate = data.kohlenhydrate
                    currentDay.maxProtein = data.protein
                    currentDay.maxFett = data.fett
                }
                return
            }
        }
        currentDay = Tag(maxK: data.kohlenhydrate, maxP: data.protein, maxF: data.fett)
        context.insert(currentDay)
        do {
            try context.save()
        } catch {
            print("Fehler in fetchDay()")
        }
    }
    
    private func dayString() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    private func getMaxKalorien() -> Int {
        let kalorien = Int(currentDay.maxKohlenhydrate * 4 + currentDay.maxProtein * 4 + currentDay.maxFett * 9)
        return kalorien
    }
    
    private func addWater() {
        currentDay.water += wasser
        do {
            try context.save()
        } catch {
            print("Fehler in addWasser")
        }
        wasser = 0
        fetchDay()
    }
    
}

#Preview {
    ContentView()
}
