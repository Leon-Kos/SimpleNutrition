//
//  ContentView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData
import Foundation

struct OverviewTop: View {
    @Environment(\.colorScheme) var colorScheme
    let currentDay: Tag
    let dateHeader: String
    @Binding var progress_kcal: Double
    @Binding var progress_kh: Double
    @Binding var progress_p: Double
    @Binding var progress_f: Double
    
    let barWidth = UIScreen.main.bounds.width * 0.6
    let rectHeight = UIScreen.main.bounds.height / 5
    
    let yOffset = 10.0
    let yOffset_dateHeader = 20.0
    
    @State private var editDay = false
    
    var body: some View {
        // Overview Top
        NavigationStack {
            VStack {
                ZStack {
                    HStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .stroke(Color.colorMode().opacity(0.2), lineWidth: 8)
                                .padding(.top, 10)
                                .frame(height: rectHeight * 0.6)
                            Circle()
                                .trim(from:0, to: progress_kcal)
                                .stroke((progress_kcal >= 1.0) ? .red : .green, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                .rotationEffect(Angle(degrees: -90))
                                .padding(.top, 10)
                                .padding(.trailing, 20)
                                .padding(.leading, 20)
                                .frame(height: rectHeight * 0.6)
                            
                            VStack(alignment: .center) {
                                Text("\(Int(currentDay.kalorien))")
                                    .padding(.top, 10)
                                    .font(.title3)
                                    .bold()
                                Text("/ \(Int(currentDay.maxKalorien))kcal")
                                    .font(.caption)
                                    .bold()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Text("Kohlenhydrate")
                                    .bold()
                                    .foregroundStyle(Color.colorKohlenhydrate())
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(currentDay.kohlenhydrate)) / \(Int(currentDay.maxKohlenhydrate))g")
                                    .bold()
                                    .font(.caption)
                                    .padding(.trailing, 20)
                                
                            }
                            // Progress von Kohlenhydraten
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.colorMode().opacity(0.2))
                                    .frame(width: barWidth, height: 5)
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: barWidth * progress_kh, height: 5)
                                    .foregroundStyle(Color.colorKohlenhydrate())
                            }
                            
                            HStack(spacing: 0) {
                                Text("Protein")
                                    .bold()
                                    .foregroundStyle(Color.colorProtein())
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(currentDay.protein)) / \(Int(currentDay.maxProtein))g")
                                    .bold()
                                    .font(.caption)
                                    .padding(.trailing, 20)
                                
                            }
                            //Progress Protein
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.colorMode().opacity(0.2))
                                    .frame(width: barWidth, height: 5)
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.colorProtein())
                                    .frame(width: barWidth * progress_p, height: 5)
                            }
                            HStack(spacing: 0) {
                                Text("Fett")
                                    .bold()
                                    .foregroundStyle(Color.colorFett())
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(currentDay.fett)) / \(Int(currentDay.maxFett))g")
                                    .bold()
                                    .font(.caption)
                                    .padding(.trailing, 20)
                                
                            }
                            // Progress Fett
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.colorMode().opacity(0.2))
                                    .frame(width: barWidth, height: 5)
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(Color.colorFett())
                                    .frame(width: barWidth * progress_f, height: 5)
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width)
                    .padding(.horizontal, 20)
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            
        }
        
    }
    
}

