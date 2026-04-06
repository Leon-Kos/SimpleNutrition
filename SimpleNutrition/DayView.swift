//
//  DayView.swift
//  SimpleNutrition
//
//

import SwiftUI
import SwiftData

struct DayView: View {
    @Environment(\.modelContext) var context
    @Query var foods: [Food]
    
    let currentDay: Tag
    let dateHeader: String
    @State var progress_kcal = 0.0
    @State var progress_kh = 0.0
    @State var progress_p = 0.0
    @State var progress_f = 0.0
    @State var progress_w = 0.0
    
    @State private var addFood = false
        
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Übersicht")
                        .font(.title3)
                        .bold()
                    Spacer()
                }
                .padding(.leading, 20)
                    
                OverviewTop(
                    currentDay: currentDay,
                    dateHeader: dateHeader,
                    progress_kcal: $progress_kcal,
                    progress_kh: $progress_kh,
                    progress_p: $progress_p,
                    progress_f: $progress_f
                )
                
//                HStack {
//                    Text("Wasser")
//                        .font(.title)
//                        .bold()
//                    Spacer()
//                }
//                .padding(.leading, 20)
//                
//                WasserOverview(currentDay: currentDay/*, progress_w: $progress_w*/)
                
                List {
                    HStack {
                        Text("Heutige Mahlzeiten")
                            .font(.title3)
                            .bold()
                        Spacer()
                        Button {
                            addFood = true
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                            }
                            .padding(.trailing, 20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .hideListEdges()
                    // Heutige Mahlzeiten - Kompakt
                    if(currentDay.getTracked().isEmpty) {
                        Text("Du hast heute noch nichts hinzugefügt. Klicke auf \"+\" um etwas zu scannen")
                            .padding(.horizontal, 20)
                            .hideListEdges()
                            .multilineTextAlignment(.center)
                            .opacity(0.5)
                    } else {
                        ForEach(currentDay.getTracked()) { food in
                            NavigationLink {
                                FoodView(day: currentDay, food: food)
                            } label: {
                                HStack(alignment: .top) {
                                    Image(systemName: "fork.knife")
                                        .font(.system(size: 30))
                                    VStack {
                                        HStack(alignment: .top) {
                                            Text(food.productName ?? "Unbekannt") // Product Name
                                                .bold()
                                            Spacer()
                                            Text("\(Int(food.scaledEnergyKcal ?? 0.0))kcal")
                                                .bold()
                                        }
                                        HStack {
                                            Text(food.categories ?? "") // Amount
                                                .opacity(0.5)
                                            Spacer()
                                        }
                                    }
                                    .swipeActions(edge: .trailing) {
                                        HStack(spacing: 10) {
                                            Button(role: .destructive) {
                                                delete_food(food: food)
                                                getProgress()
                                            } label: {
                                                Image(systemName: "trash")
                                                    .font(.system(size: 20))
                                                    .foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                                .padding(.bottom, 10)
                            }
                            .hideListEdges()
                            .padding(.leading, 20)
                            .padding(.trailing, 20)
                        }
                    }
                    
                }
                .onAppear {
                    getProgress()
                }
                .listStyle(.plain)
                
                Spacer()
            }
            .navigationTitle(currentDay.getDateHeader())
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $addFood) {
                AddSavedFoodView(currentDay: currentDay)
            }
        }
    }

    private func delete_food(food: Food) {
        currentDay.removeFood(food: food)
        //context.delete(food)
        do {
            try context.save()
        } catch {
            print("Error in delete_Food() in Overview")
        }
    }
    
    private func getProgress() {
        let progress = currentDay.getProgress()
        progress_kcal = progress["kcal"] ?? 0.0
        progress_kh = progress["kh"] ?? 0.0
        progress_p = progress["p"] ?? 0.0
        progress_f = progress["f"] ?? 0.0
        progress_w = progress["w"] ?? 0.0
    }
        
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: Tag.self, configurations: config)
//    let tag = Tag(maxK: 250, maxP: 240, maxF: 70)
//    
//    
//    
//    DayView(currentDay: tag, dateHeader: tag.getDateHeader(), progress_kcal: 0.0, progress_kh: 0.0, progress_p: 0.0, progress_f: 0.0).modelContainer(container)
//}
