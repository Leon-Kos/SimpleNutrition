//
//  ContentView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData
import Foundation

struct CurrentDayView: View {
    @Environment(\.modelContext) var context
    @Environment(\.colorScheme) var colorScheme
    @Query var foods: [Food]
    @Query(sort: \Tag.date, order: .reverse) var days: [Tag]

    
    let currentDay: Tag
    
    
    var body: some View {
        NavigationStack {
            DayView(currentDay: currentDay, dateHeader: currentDay.getDateHeader())
        }
    }
    
}

//#Preview {
//    CurrentDayView()
//}
