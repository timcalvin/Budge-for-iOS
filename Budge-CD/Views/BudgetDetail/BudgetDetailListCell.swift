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
    
    @FocusState var priceTextIsFocused: Bool
    @FocusState var quantityTextIsFocused: Bool
    @FocusState var couponTextIsFocused: Bool
    
    var body: some View {
        
        VStack {
            
            // MARK: - Collapsed item
            HStack {
                
                Button {
                    showingItemDetail.toggle()
                    priceIsFocused.toggle()
                    priceTextIsFocused.toggle()
                    quantityIsFocused.toggle()
                    quantityTextIsFocused.toggle()
                    couponIsFocused.toggle()
                    couponTextIsFocused.toggle()
                    taxIsFocused.toggle()
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
                                quantityTextIsFocused = false
                                taxIsFocused = false
                                couponIsFocused = false
                                couponTextIsFocused = false
                                priceIsFocused = true
                                priceTextIsFocused = true
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "dollarsign.circle")
                                    .foregroundColor(priceIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // QUANTITY BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = true
                                quantityTextIsFocused = true
                                taxIsFocused = false
                                couponIsFocused = false
                                couponTextIsFocused = false
                                priceIsFocused = false
                                priceTextIsFocused = false
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "xmark.circle")
                                    .foregroundColor(quantityIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // COUPON BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = false
                                quantityIsFocused = false
                                taxIsFocused = false
                                couponIsFocused = true
                                couponTextIsFocused = true
                                priceIsFocused = false
                                priceTextIsFocused = false
                                HapticManager.instance.impact(style: .light)
                            } label: {
                                ComponentLabel(image: "scissors.circle")
                                    .foregroundColor(couponIsFocused ? itemColor : .budgeLightGray)
                            }
                            
                            // TAXABLE BUTTON
                            Button {
                                // Set focus to price
                                quantityIsFocused = false
                                quantityTextIsFocused = false
                                taxIsFocused = true
                                couponIsFocused = false
                                couponTextIsFocused = false
                                priceIsFocused = false
                                priceTextIsFocused = false
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
                                    quantityTextIsFocused = false
                                    taxIsFocused = false
                                    couponIsFocused = false
                                    couponTextIsFocused = false
                                    priceIsFocused = true
                                    priceTextIsFocused = true
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
                                
                                ZStack {
                                    TextField("Price", value: $itemValue, format: Constants.currencyFormat)
//                                        .modifier(TextFieldClearButton(value: $itemValue))
                                        .keyboardType(.decimalPad)
                                        .focused($priceTextIsFocused)
                                        .onChange(of: itemValue) { newValue in
                                            vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: newValue, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: item.isInCart)
                                        }
//                                    HStack {
//                                        Spacer()
//                                        Button {
//                                            itemValue = 0
//                                        } label: {
//                                            Image(systemName: "x.circle.fill")
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: 20, height: 20)
//                                                .foregroundColor(.budgeLightGray)
//                                        }
//                                    }
                                }
                                .toolbar {
                                    ToolbarItemGroup(placement: .keyboard) {
                                        HStack {
                                            Spacer()
                                            Button {
                                                priceTextIsFocused = false
                                            } label: {
                                                Text("Done")
                                                    .foregroundColor(.budgeBlue)
                                            }
                                        }
                                    }
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
                                    .focused($quantityTextIsFocused)
                                    .onChange(of: itemQuantity) { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: newValue, value: item.value, isTaxable: item.isTaxable, couponValue: item.couponValue, isInCart: item.isInCart)
                                    }
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            HStack {
                                                Spacer()
                                                Button {
                                                    quantityTextIsFocused = false
                                                } label: {
                                                    Text("Done")
                                                        .foregroundColor(.budgeBlue)
                                                }
                                            }
                                        }
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
                                    .focused($couponTextIsFocused)
                                    .onChange(of: itemCouponValue) { newValue in
                                        vm.updateItem(item, inBudget: budget, name: item.name ?? "", quantity: item.quantity, value: item.value, isTaxable: item.isTaxable, couponValue: newValue, isInCart: item.isInCart)
                                    }
                                    .toolbar {
                                        ToolbarItemGroup(placement: .keyboard) {
                                            HStack {
                                                Spacer()
                                                Button {
                                                    couponTextIsFocused = false
                                                } label: {
                                                    Text("Done")
                                                        .foregroundColor(.budgeBlue)
                                                }
                                            }
                                        }
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
