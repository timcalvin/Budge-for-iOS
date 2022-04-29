//
//  Budgets.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

// TODO: - Add sort options

import SwiftUI

struct Budgets: View {
    
    // Core Data reference
    @ObservedObject var vm: ViewModel
    
    // State properties
    @State private var showingBudgetDetail = false
    @State private var showingSortOptions = false
    
    // Layout properties
    var layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(colors: [.budgeBlue, .budgeTeal], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if vm.budgets.count > 0 {
                    
                    ScrollView(showsIndicators: false) {
                        // FIXME: - This isn't being created when the view first comes to be
                        LazyVGrid(columns: layout, spacing: 20) {
                            ForEach(vm.budgets) { budget in
                                // TODO: - Sorting
                                NavigationLink {
                                    BudgetDetail(vm: vm, budget: budget)
                                } label: {
                                    BudgetListButton(vm: vm, budget: budget)
                                }
                            }
                            .padding(.bottom)
                            
                            Button {
                                showingBudgetDetail = true
                            } label: {
                                BudgetListButton(vm: vm, budget: nil)
                            }
                            .padding(.bottom)
                            .sheet(isPresented: $showingBudgetDetail) {
                                BudgetSetup(vm: vm)
                            }
                        }
                        .padding()
                    }
                    .padding(.top, 1)
                    
                } else {
                    
                    // Budgets do not exist
                    VStack {
                        Spacer()
                        Button {
                            showingBudgetDetail = true
                        } label: {
                            // FIXME: - I want 120 frameSize
                            BudgetListButton(vm: vm, budget: nil)
                        }
                        .sheet(isPresented: $showingBudgetDetail) {
                            BudgetSetup(vm: vm)
                        }
                        Spacer()
                    }
                    
                }
                
            }
            .navigationTitle("Budgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSortOptions.toggle()
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundColor(.white)
                    }
                }
            }
            .actionSheet(isPresented: $showingSortOptions) {
                ActionSheet(title: Text("Sort Method"),
                            message: Text("Choose how you would like your budgets sorted."),
                            buttons: [
                                .cancel(),
                                .default(Text("Name Ascending"), action: {
                                    // TODO
                                }),
                                .default(Text("Name Descending"), action: {
                                    // TODO
                                }),
                                .default(Text("Dated Added Ascending"), action: {
                                    // TODO
                                }),
                                .default(Text("Date Added Descending"), action: {
                                    // TODO
                                })
                            ])
            }
            
        }
        .onAppear {
            vm.getBudgets()
        }
        
//        .preferredColorScheme(.dark)
    }

}
