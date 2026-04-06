//
//  LogView.swift
//  SimpleNutrition
//
//

import Foundation
import SwiftUI
import SwiftData

struct LogView: View {
    @Environment(\.modelContext) var context
    //@Query(sort: \Tag.date, order: .reverse) var days: [Tag]
    
    let days: [Tag]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(days) { day in
                    NavigationLink {
                        DayView(currentDay: day, dateHeader: day.getDateHeader())
                    } label: {
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(day.getDateHeader().localizedCapitalized)
                                        .bold()
                                    Text("\(Int(day.kalorien))kcal - Ziel: \(Int(day.maxKalorien))kcal")
                                        .font(.caption)
                                        .opacity(0.5)
                                        .bold()
                                }
                                Spacer()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 50)
                                        .foregroundStyle(
                                            progressBoundCheck(day: day) ?
                                            Color(red: 0.918, green: 0.953, blue: 0.871) :
                                                Color(red: 0.988, green: 0.922, blue: 0.922)
                                        )
                                        .frame(
                                            maxWidth: UIScreen.main.bounds.width / 4,
                                            maxHeight: UIScreen.main.bounds.height * 0.04
                                        )
                                    if(progressBoundCheck(day: day)) {
                                        Text("Ziel erreicht")
                                            .foregroundStyle(Color(red: 0.231, green: 0.427, blue: 0.067))
                                            .font(.caption)
                                            .bold()
                                    } else {
                                        Text("+\(Int(day.kalorien) - Int(day.maxKalorien)) kcal")
                                            .foregroundStyle(Color(red: 0.639, green: 0.176, blue: 0.176))
                                            .font(.caption)
                                            .bold()
                                    }
                                }
                            }
                            HStack {
                                Spacer()
                                VStack {
                                    Text("KH")
                                        .bold()
                                    Text("\(Int(day.kohlenhydrate))g")
                                        .foregroundStyle(Color.colorKohlenhydrate())
                                        .bold()
                                }
                                Spacer()
                                Divider()
                                    .frame(width: 1, height: 28)
                                Spacer()
                                VStack {
                                    Text("Protein")
                                        .bold()
                                    Text("\(Int(day.protein))g")
                                        .foregroundStyle(Color.colorProtein())
                                        .bold()
                                }
                                Spacer()
                                Divider()
                                    .frame(width: 1, height: 28)
                                Spacer()
                                VStack {
                                    Text("Fett")
                                        .bold()
                                    Text("\(Int(day.fett))g")
                                        .foregroundStyle(Color.colorFett())
                                        .bold()
                                }
                                Spacer()
                                Divider()
                                    .frame(width: 1, height: 28)
                                Spacer()
                                VStack {
                                    Text("Wasser")
                                        .bold()
                                    Text("\(Int(day.wasser))mL")
                                        .foregroundStyle(Color.colorWasser())
                                        .bold()
                                }
                                Spacer()
                            }
                            .padding(.bottom, 30)
                        }
                    }
                    .hideListEdges()
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .swipeActions(edge: .trailing) {
                        HStack(spacing: 10) {
                            Button(role: .destructive) {
                                delete_day(day: day)
                            } label: {
                                Image(systemName: "trash")
                                    .font(.system(size: 20))
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
    
    func printDays() {
        for day in days {
            print(day.getDateHeader())
        }
    }
    
    func delete_day(day: Tag) {
        context.delete(day)
        do {
            try context.save()
        } catch {
            print("Fehler in delete_day()")
        }
    }
    
    private func progressBoundCheck(day: Tag) -> Bool {
        return Int(day.kalorien) <= Int(day.maxKalorien)
    }
}

//#Preview {
//    LogView()
//}
