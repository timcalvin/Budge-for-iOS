//
//  BudgetDetailCart.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/24/22.
//

import SwiftUI

struct BudgetDetailCart: View {
    
    // Environment
    @ObservedObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    
    // Budget
    var budget: Budget
    
    var budgetColor: Color {
        let color = vm.iconColor(fromBudgetColor: budget.unwrappedThemeColor)
        return color == .white ? .budgeBlue : color
    }
    
    @State private var showingEmptyCartConfirmation = false
    @State private var showingCartIsEmptyAlert = false
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                
                if budget.itemsArray.count > 0 {
                    ForEach(budget.itemsArray) { item in
                        // TODO: - Add sorting (see old project or use predicate)
                        if item.isInCart {
                            BudgetDetailCartCell(vm: vm, budget: budget, item: item)
                        }
                    }
                }
                
                // CART TOTAL
                HStack {
                    Spacer()
                    Text("\(budget.unwrappedName) cart total: ")
                        .bold()
                        .foregroundColor(.budgeDarkGray)
                    if budget.cartValue != 0 {
                        Text(budget.cartValue, format: Constants.currencyFormat)
                            .bold()
                            .foregroundColor(.red)
                            .frame(width: 70)
                    } else {
                        Text(0.0, format: Constants.currencyFormat)
                            .bold()
                            .foregroundColor(.budgeDarkGray)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onTapGesture {
            dismissKeyboard()
        }
        Spacer()
        
        if vm.getNumberOfItemsInCart(budget: budget) > 0 {
            Button {
                if vm.getNumberOfItemsInCart(budget: budget) > 0 {
                    showingEmptyCartConfirmation = true
                } else {
                    showingCartIsEmptyAlert = true
                    HapticManager.instance.notification(type: .error)
                }
            } label: {
                Text("Empty Cart")
            }
            .buttonStyle(BudgeButton(buttonColor: .red, textColor: .white))
            .padding(.vertical)
            .alert("Empty Cart", isPresented: $showingEmptyCartConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("Empty", role: .destructive) {
                    vm.emptyCart(fromBudget: budget)
                    HapticManager.instance.notification(type: .success)
                }
            } message: {
                Text("Are you sure you want to remove all items from the cart? This cannot be undone.")
            }
            .alert("Your Cart Is Already Empty", isPresented: $showingCartIsEmptyAlert) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("Your cart is already empty. There are no items to remove.")
            }
            .onAppear(perform: {
            })
            .padding(.horizontal)
        }
    }
}
