//import SwiftUI
//import SwiftData
//import Foundation
//
//// OverviewTop is no longer used by DayView (hero card is now inline).
//// Kept compilable with updated color tokens.
//struct OverviewTop: View {
//    @Environment(\.colorScheme) var colorScheme
//    let currentDay: Tag
//    let dateHeader: String
//    @Binding var progress_kcal: Double
//    @Binding var progress_kh: Double
//    @Binding var progress_p: Double
//    @Binding var progress_f: Double
//
//    let barWidth   = UIScreen.main.bounds.width * 0.6
//    let rectHeight = UIScreen.main.bounds.height / 5
//
//    var body: some View {
//        VStack {
//            HStack(spacing: 0) {
//                ZStack {
//                    Circle()
//                        .stroke(Color.snTint, lineWidth: 8)
//                        .padding(.top, 10)
//                        .frame(height: rectHeight * 0.6)
//                    Circle()
//                        .trim(from: 0, to: progress_kcal)
//                        .stroke(
//                            progress_kcal >= 1.0 ? Color.snWarn : Color.snPrimary,
//                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
//                        )
//                        .rotationEffect(Angle(degrees: -90))
//                        .padding(.top, 10)
//                        .padding(.horizontal, 20)
//                        .frame(height: rectHeight * 0.6)
//
//                    VStack(alignment: .center) {
//                        Text("\(Int(currentDay.kalorien))")
//                            .padding(.top, 10)
//                            .font(.title3).bold()
//                        Text("/ \(Int(currentDay.maxKalorien))kcal")
//                            .font(.caption).bold()
//                    }
//                }
//
//                VStack(alignment: .leading) {
//                    macroRow(label: "Kohlenhydrate", value: currentDay.kohlenhydrate, max: currentDay.maxKohlenhydrate, progress: progress_kh, color: .snCarbs)
//                    macroRow(label: "Protein",       value: currentDay.protein,       max: currentDay.maxProtein,       progress: progress_p,  color: .snProtein)
//                    macroRow(label: "Fett",          value: currentDay.fett,          max: currentDay.maxFett,          progress: progress_f,  color: .snFat)
//                }
//            }
//            .frame(width: UIScreen.main.bounds.width)
//            .padding(.horizontal, 20)
//        }
//        .frame(width: UIScreen.main.bounds.width)
//    }
//
//    private func macroRow(label: String, value: Double, max: Double, progress: Double, color: Color) -> some View {
//        VStack(alignment: .leading, spacing: 2) {
//            HStack(spacing: 0) {
//                Text(label).bold().foregroundStyle(color).font(.caption)
//                Spacer()
//                Text("\(Int(value)) / \(Int(max))g").bold().font(.caption).padding(.trailing, 20)
//            }
//            ZStack(alignment: .leading) {
//                RoundedRectangle(cornerRadius: 20).fill(Color.snInk.opacity(0.08)).frame(width: barWidth, height: 5)
//                RoundedRectangle(cornerRadius: 20).frame(width: barWidth * progress, height: 5).foregroundStyle(color)
//            }
//        }
//    }
//}
