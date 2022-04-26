//
//  BudgetDetailListCell.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/25/22.
//

import SwiftUI

struct BudgetDetailListCell: View {
    
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
    
    var body: some View {
        
        VStack {
            
            // MARK: - Collapsed item
            HStack {
                
                Button {
                    showingItemDetail.toggle()
                    priceIsFocused = true
                    HapticManager.instance.impact(style: .rigid)
                } label: {
                    Image(systemName: !showingItemDetail ? "circle" : "circle.inset.filled")
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
                
            }
            
            // MARK: - Item detail buttons
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
                            
                            // DELETE BUTTON
                            Button {
                                withAnimation {
                                    vm.deleteItem(item: item)
                                }
                                HapticManager.instance.impact(style: .rigid)
                            } label: {
                                ComponentLabel(image: "trash.circle")
                                    .foregroundColor(.red)
                            }
                            
                            // TO CART BUTTON
                            Button {
                                if item.value == 0 {
                                    HapticManager.instance.notification(type: .warning)
                                    showingPriceAlert = true
                                } else {
                                    
                                    withAnimation {
                                        // Calculate item total
                                        let itemTotal = vm.itemTotal(item: item)
                                        
                                        // Update item total and add it to the cart
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: itemCouponValue, isInCart: true, itemTotal: itemTotal)
                                        
                                        // Update the budgets cart total
                                        vm.updateBudgetCartValue(budget: budget, itemValue: itemTotal, addingToCart: true)
                                        
                                        HapticManager.instance.notification(type: .success)
                                    }

                                }
                            } label: {
                                ComponentLabel(image: "cart.circle")
                                    .foregroundColor(.green)
                            }
                            .alert("Item Has No Value", isPresented: $showingPriceAlert) {
                                Button("Add Price", role: .cancel) {
                                    quantityIsFocused = false
                                    taxIsFocused = false
                                    couponIsFocused = false
                                    priceIsFocused = true
                                }
                                Button("Add To Cart", role: .destructive) {
                                    vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: true)
                                    HapticManager.instance.notification(type: .success)
                                }
                            } message: {
                                Text("Are you sure you want to add this item to the cart. It currently has no price.")
                            }
                        }
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                        Divider()
                        
                        // MARK: - Item detail settings
                        VStack(alignment: .leading) {
                            
                            // PRICE
                            if priceIsFocused {
                                Text("Price")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.budgeDarkGray)
                                
                                TextField("Price", value: $itemValue, format: Constants.currencyFormat)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: itemValue) { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: newValue, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: item.isInCart)
                                        HapticManager.instance.impact(style: .light)
                                    }
                            }
                            
                            // QUANTITY
                            else if quantityIsFocused {
                                Text("Quantity")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.budgeDarkGray)
                                
                                TextField("Quantity", value: $itemQuantity, format: .number)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: itemQuantity) { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: newValue, value: item.value, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: item.isInCart)
                                        HapticManager.instance.impact(style: .light)
                                    }
                            }
                            
                            // COUPON
                            else if couponIsFocused {
                                Text("Coupon")
                                    .bold()
                                    .font(.caption)
                                    .foregroundColor(.budgeDarkGray)
                                
                                TextField("Coupon", value: $itemCouponValue, format: Constants.currencyFormat)
                                    .keyboardType(.decimalPad)
                                    .onChange(of: itemCouponValue) { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: newValue, isInCart: item.isInCart)
                                        HapticManager.instance.impact(style: .light)
                                    }
                            }
                            
                            // TAX
                            else if taxIsFocused {
                                HStack {
                                    Toggle(isOn: $itemIsTaxableToggle) {
                                        Text("TAXABLE")
                                            .foregroundColor(.budgeDarkGray)
                                    }
                                    .onChange(of: itemIsTaxableToggle, perform: { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: newValue, couponValue: item.couponValue, isInCart: item.isInCart)
                                        HapticManager.instance.impact(style: .light)
                                    })
                                    .alert("Tax Rate Not Set", isPresented: $showingTaxAlert) {
                                        Button("OK", role: .cancel) {
                                            itemIsTaxableToggle = false
                                        }
                                    } message: {
                                        Text("Before you can mark an item as taxable, go to Settings > App Settings and set a default tax rate.")
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
        }
        .onTapGesture {
            dismissKeyboard()
        }
        
    }
}
