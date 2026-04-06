//
//  WasserOverview.swift
//  SimpleNutrition
//
//  Created by Leon Kos on 06.04.26.
//

import SwiftUI

struct WasserOverview: View {
    
    let currentDay: Tag
    //@Binding var progress_w: Double
    let progress_w = 0.5
    
    let barWidth = UIScreen.main.bounds.width * 0.6
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.colorMode().opacity(0.2))
                .frame(width: barWidth, height: 5)
            RoundedRectangle(cornerRadius: 20)
                .frame(width: barWidth * progress_w, height: 5)
                .foregroundStyle(Color.colorWasser())
        }
    }
}

#Preview {
    @Previewable var currentDay = Tag(maxK: 130, maxP: 140, maxF: 80)
    WasserOverview(currentDay: currentDay)
}
