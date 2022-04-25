//
//  BudgetSetup.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/21/22.
//

import SwiftUI

struct BudgetSetup: View {
    
    // Environment
    @ObservedObject var vm: ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Budget
    var budget: Budget?
    
    // TextFields
    @State private var budgetNameText = ""
    @State private var budgetValue: Double = 0 //{
        // FIXME: -
//        didSet {
//            budgetValue = budgetValue / 100
//        }
//    }
    
    // UI
    @FocusState var valueIsFocused: Bool
    @State private var iconColor: Color = .budgeBlue
    @State private var iconColorName = "default"
    @State private var icon = "list.bullet"
    @State private var showingDeleteAlert = false
    
    // Layout
    let iconData = Bundle.main.decode([String].self, from: "symbols.json")
    let layout = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        VStack {
            // MARK: - Header Bar
            ZStack(alignment: .top) {
                HStack {
                    
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                    Spacer()
                    
                    Button {
                        if budget == nil {
                            vm.addBudget(name: budgetNameText, value: budgetValue, icon: icon, themeColor: iconColorName)
                        } else {
                            if let budget = budget {
                                vm.updateBudget(budget: budget, name: budgetNameText, value: budgetValue, icon: icon, themeColor: iconColorName)
                            }
                        }
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Done")
                    }
                }
                
                Text(budget?.name ?? "New Budget")
                    .bold()
                    .font(.title2)
            }
            .padding()
            
            ScrollView {
                
                // MARK: - Icon, Name and Value
                Section {
                    VStack(alignment: .leading) {
                        HStack {
                            Spacer()
                            ZStack {
                                Circle()
                                    .foregroundColor(iconColor)
                                    .frame(width: 120, height: 120)
                                    .shadow(radius: 5)
                                Image(systemName: icon)
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 40)
                        
                        Text("Budget Name")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.budgeDarkGray)
                        TextField("Budget Name", text: $budgetNameText)
                            .textFieldStyle(.roundedBorder)
                            .font(.title2)
                            .padding(.bottom, 10)
                        
                        Text("Amount")
                            .bold()
                            .font(.caption)
                            .foregroundColor(.budgeDarkGray)
                        TextField("Budget Amount", value: $budgetValue, format: Constants.currencyFormat)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .focused($valueIsFocused)
                            .padding(.bottom)
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Color Options
                VStack {
                    LazyVGrid(columns: layout, alignment: .center, spacing: 20) {
                        
                        Button {
                            iconColor = .red
                            iconColorName = "red"
                        } label: {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 40, height: 40)
                        }
                        
                        Button {
                            iconColor = .orange
                            iconColorName = "orange"
                        } label: {
                            Circle()
                                .foregroundColor(.orange)
                                .frame(width: 40, height: 40)
                        }
                        
                        Button {
                            iconColor = .yellow
                            iconColorName = "yellow"
                        } label: {
                            Circle()
                                .foregroundColor(.yellow)
                                .frame(width: 40, height: 40)
                        }
                        
                        Button {
                            iconColor = .green
                            iconColorName = "green"
                        } label: {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 40, height: 40)
                        }
                        
                        Button {
                            iconColor = .budgeBlue
                            iconColorName = "default"
                        } label: {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 40, height: 40)
                        }
                        
                        Button {
                            iconColor = .purple
                            iconColorName = "purple"
                        } label: {
                            Circle()
                                .foregroundColor(.purple)
                                .frame(width: 40, height: 40)
                        }
                        
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Icons
                Section {
                    LazyVGrid(columns: layout, alignment: .center, spacing: 20, content: {
                        ForEach(iconData, id: \.self) { icon in
                            Button {
                                self.icon = icon
                            } label: {
                                ZStack {
                                    Circle()
                                        .foregroundColor(.budgeLightGray)
                                        .frame(width: 40, height: 40)
                                    Image(systemName: icon)
                                        .foregroundColor(.budgeDarkGray)
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                    })
                    .padding(.vertical)
                }
                .padding(.horizontal)
            }
            
            // MARK: - Delete Button
            if budget != nil {
                Button {
                    showingDeleteAlert = true
                } label: {
                    Text("Delete Budget")
                }
                .buttonStyle(BudgeButton(buttonColor: .red, textColor: .white))
                .alert(isPresented: $showingDeleteAlert) {
                    Alert(
                        title: Text("Delete \(budget?.name ?? "Budget")"),
                        message: Text("Please tap Delete to confirm you would like to delete this budget."),
                        primaryButton: .default(
                            Text("Cancel")
                        ),
                        secondaryButton: .destructive(
                            Text("DELETE")) {
                                if let budget = budget {
                                    vm.deleteBudget(budget: budget)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }
                    )
                }
                .padding()
            }
            
        }
        .onTapGesture {
            dismissKeyboard()
        }
        .onAppear {
            if let budget = budget {
                budgetNameText = budget.name ?? "New Budget"
                budgetValue = budget.value
                icon = budget.icon ?? "list.bullet"
                iconColorName = budget.themeColor ?? "default"
                iconColor = vm.iconColor(fromBudgetColor: budget.themeColor ?? "default")
            }
        }
    }
}
