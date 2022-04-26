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
    @State private var showingAdjustTotal = false
    @State private var adjustTotalValue = 0.0
    @State private var shouldAdjustUp = true
//    @State private var currentBudget = 0.0
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                
                if budget.itemsArray.count > 0 {
                    ForEach(budget.itemsArray) { item in
                        // TODO: - Add sorting (see old project or use predicate)
                        if item.isInCart {
//                            BudgetDetailCartCell(vm: vm, budget: budget, item: item)
                        }
                    }
                }
                
                // CART SUBTOTAL
                HStack {
                    Spacer()
                    Text("\(budget.unwrappedName) cart subtotal: ")
                        .bold()
                        .foregroundColor(.budgeDarkGray)
                    if let cartSubtotal = vm.getCartSubtotal(budget: budget) {
                        Text(cartSubtotal, format: Constants.currencyFormat)
                            .bold()
                            .foregroundColor(.red)
                            .frame(width: 70)
                    } else {
                        Text(0.0, format: Constants.currencyFormat)
                            .bold()
                            .foregroundColor(.budgeDarkGray)
                    }
                    Button {
                        showingAdjustTotal.toggle()
                    } label: {
                        if showingAdjustTotal {
                            ComponentLabel(image: "chevron.down.circle.fill")
                        } else {
                            ComponentLabel(image: "chevron.right.circle.fill")
                        }
                    }
                    .foregroundColor(budgetColor)
                }
                
                // ADJUSTMENT
                if showingAdjustTotal {
                    HStack {
                        Spacer()
                        Text("Adjust total: ")
                            .bold()
                            .foregroundColor(.budgeDarkGray)
                        TextField("Adjustment", value: $adjustTotalValue, format: Constants.currencyFormat)
                            .keyboardType(.decimalPad)
                            .frame(width: 65)
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing, 6)
                            .onChange(of: adjustTotalValue) { adjustment in
                                vm.updateBudgetValue(budget: budget, newValue: shouldAdjustUp ? budget.value + adjustment : budget.value - adjustment)
                            }
                        Button {
                            shouldAdjustUp.toggle()
                            vm.updateBudgetValue(budget: budget, newValue: shouldAdjustUp ? budget.value + adjustTotalValue : budget.value - adjustTotalValue)
                        } label: {
                            if shouldAdjustUp {
                                ComponentLabel(image: "plus.circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                ComponentLabel(image: "minus.circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    // CART TOTAL
                    HStack {
                        Spacer()
                        Text("Total with adjustments: ")
                            .bold()
                            .foregroundColor(.budgeDarkGray)
                        
                        if let cartTotal = vm.getCartTotal(budget: budget, adjustment: adjustTotalValue, shouldAdjustUp: shouldAdjustUp) {
                            Text(cartTotal, format: Constants.currencyFormat)
                            .bold()
                            .foregroundColor(.red)
                            .frame(width: 70)
                        }
                        ComponentLabel(image: "circle")
                            .foregroundColor(.white)
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
    //                currentBudget = budget.budget
                    adjustTotalValue = 0
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
            .padding(.horizontal)
        }
    }
}
