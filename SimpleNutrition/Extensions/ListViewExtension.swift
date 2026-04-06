//
//  ListViewExtension.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 27.03.26.
//


import SwiftUI

extension View {
    func hideListEdges() -> some View {
         self
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}
