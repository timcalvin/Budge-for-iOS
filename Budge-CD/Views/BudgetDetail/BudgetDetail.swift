//
//  BudgetDetail.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/23/22.
//

import SwiftUI

struct BudgetDetail: View {
    
    // Environment
    @ObservedObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    
    // Budget
    var budget: Budget
    
    // State properties
    @State private var budgetListTab = BudgetDetailTab.list
    @State private var showingBudgetDetail = false
    @State private var showingBudgetDetailSort = false
    
    var budgetColor: Color {
        let color = vm.iconColor(fromBudgetColor: budget.unwrappedThemeColor)
        return color == .white ? .budgeBlue : color
    }
    
    var headlineColor: Color {
//        budgetColor == .white || budgetColor == .yellow ? .budgeDarkGray : .white
        .white
    }
    
    var body: some View {
        
        VStack {
            
            // MARK: - Budget Display
            ZStack {
                Rectangle()
                    .foregroundColor(budgetColor)
                    .ignoresSafeArea(edges: .top)
                HStack {
                    Text(budget.value - budget.cartValue, format: Constants.currencyFormat)
                        .bold()
                        .foregroundColor(headlineColor)
                        .font(.title)
                        .padding()
                }
            }
            .frame(height: 60)
            
            HStack {
                Picker(selection: $budgetListTab) {
                    Text(budget.name ?? "")
                        .tag(BudgetDetailTab.list)
                    Text("Cart")
                        .tag(BudgetDetailTab.cart)
                } label: {
                    Text("Budget Detail Tab")
                }
                .pickerStyle(.segmented)
                
                Button {
                    showingBudgetDetailSort = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.budgeDarkGray)
                }
                .actionSheet(isPresented: $showingBudgetDetailSort) {
                    ActionSheet(title: Text("Sort Method"),
                                message: Text("Choose how you would like the items in your list sorted."),
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
            .padding(.horizontal)
            
            if budgetListTab == .list {
                BudgetDetailList(vm: vm, budget: budget)
            } else if budgetListTab == .cart {
                BudgetDetailCart(vm: vm, budget: budget)
            }
            Spacer()
        }
        .sheet(isPresented: $showingBudgetDetail) {
            BudgetSetup(vm: vm, budget: budget)
        }
        .navigationBarTitle(budget.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
//        .preferredColorScheme(headlineColor == .white ? .light : .dark)
        .toolbar {
            Button {
                showingBudgetDetail = true
            } label: {
                Image(systemName: "ellipsis.circle")
            }
        }
        .onAppear {
            vm.updateTaxRate()
        }
    }
}

