//
//  BudgetDetailCartCell.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/26/22.
//

import SwiftUI

struct BudgetDetailCartCell: View {
    
    // Environment
    @ObservedObject var vm: ViewModel
    
    // Budget
    var budget: Budget
    var item: Item
    var itemColor: Color {
        vm.iconColor(fromBudgetColor: budget.themeColor ?? "default") == .white ? .budgeBlue : vm.iconColor(fromBudgetColor: budget.themeColor ?? "default")
    }
    
    // UI
    @State private var showingItemDetail = false
    @State private var showingPriceAlert = false
    @State private var showingTaxAlert = false
    
    @State private var priceIsFocused = false
    @State private var quantityIsFocused = false
    @State private var taxIsFocused = false
    @State private var couponIsFocused = false
    
    @State private var itemNameText = ""
    @State private var itemValue = 0.0
    @State private var itemQuantity = 1.0
    @State private var itemIsTaxableToggle = false
    @State private var itemCouponValue = 0.0
    @State private var itemTotal = 0.0
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // MARK: - Collapsed item
            HStack {
                
                Button {
                    showingItemDetail.toggle()
                    priceIsFocused = true
                    HapticManager.instance.impact(style: .rigid)
                } label: {
                    Image(systemName: !showingItemDetail ? "circle.inset.filled" : "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(itemColor)
                }
                
                TextField("Item Name", text: $itemNameText, prompt: Text("enter item name..."))
                    .foregroundColor(.budgeDarkGray)
                    .onChange(of: itemNameText) { newValue in
                        vm.updateItem(item, inBudget: budget, name: newValue, quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: item.isInCart)
                        print("TCB: Item name changed")
                        HapticManager.instance.impact(style: .light)
                    }
                Spacer()
                
                Text(itemTotal, format: Constants.currencyFormat)
                    .foregroundColor(.budgeLightGray)
                    .layoutPriority(1)
                
            }
            
            // MARK: - Item Detail Buttons
            
            if showingItemDetail {
                ZStack {
                    
                    Rectangle()
                        .foregroundColor(.budgetCellGray)
                        .padding(.horizontal, -20)
                    
                    VStack {
                        
                        HStack(spacing: 20) {
                            
                            // PRICE BUTTON
                            Button {
                                quantityIsFocused = false
                                taxIsFocused = false
                                couponIsFocused = false
                                priceIsFocused = true
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "dollarsign.circle")
                                    .foregroundColor(priceIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // QUANTITY BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = true
                                taxIsFocused = false
                                couponIsFocused = false
                                priceIsFocused = false
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "xmark.circle")
                                    .foregroundColor(quantityIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // COUPON BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = false
                                taxIsFocused = false
                                couponIsFocused = true
                                priceIsFocused = false
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "scissors.circle")
                                    .foregroundColor(couponIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // TAXABLE BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = false
                                taxIsFocused = true
                                couponIsFocused = false
                                priceIsFocused = false
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "staroflife.circle")
                                    .foregroundColor(taxIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            Spacer()
                            
                            // Remove From Cart Button
                            Button {

                                withAnimation {                                    
                                    vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: itemCouponValue, isInCart: false, itemTotal: itemTotal)
                                    
                                    vm.updateBudgetCartValue(budget: budget, itemValue: itemTotal, addingToCart: false)
                                    
                                    HapticManager.instance.notification(type: .success)
                                }
                                
                            } label: {
                                ComponentLabel(image: "cart.circle")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Divider()
                        
                        // MARK: - Item Detail Settings
                        VStack(alignment: .leading) {
                            
                            if taxIsFocused {
                                HStack {
                                    Toggle(isOn: $itemIsTaxableToggle) {
                                        Text("TAXABLE")
                                            .foregroundColor(.budgeDarkGray)
                                    }
                                    .onChange(of: itemIsTaxableToggle) { newValue in
                                        // Change the item value
                                        // Adjust the budget
                                        // Persist the change
                                        //provide some haptic feedback
                                    }
                                    .tint(itemColor)
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            Divider()
        }
        .onAppear {
            itemNameText = item.name ?? ""
            itemValue = item.value
            itemQuantity = item.quantity
            itemIsTaxableToggle = item.isTaxable
            itemCouponValue = item.couponValue
            itemTotal = item.itemTotal
        }
        .onTapGesture {
            dismissKeyboard()
        }
    }
}
