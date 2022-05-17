//
//  BudgetDetailList.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/24/22.
//

import SwiftUI

struct BudgetDetailList: View {
    
    // Environment
    @ObservedObject var vm: ViewModel
    @Environment(\.dismiss) var dismiss
    
    // Budget
    var budget: Budget
    
    var budgetColor: Color {
        let color = vm.iconColor(fromBudgetColor: budget.unwrappedThemeColor)
        return color == .white ? .budgeBlue : color
    }
    
    @State private var newItemText = ""
    @FocusState private var newItemIsFocused: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                if budget.itemsArray.count > 0 {
                    // TODO: - Add some sorting (refer to old project)
                    ForEach(budget.itemsArray) { item in
                        if !item.isInCart {
                            BudgetDetailListCell(vm: vm, budget: budget, item: item)
                        }
                    }
                }
                
                HStack {
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundColor(.budgeLightGray)
                    TextField("New Item", text: $newItemText, prompt: Text("add new item..."))
//                        .modifier(TextFieldClearButton(text: $newItemText))
                        .focused($newItemIsFocused)
                        .submitLabel(SubmitLabel.done)
                        .autocapitalization(.words)
                        .onSubmit {
                            withAnimation {
                                vm.addItem(toBudget: budget, withName: newItemText)
                                newItemText = ""
                                newItemIsFocused = true
                            }
                        }
                    Divider()
                }
            }
            .padding(.horizontal)
            .onTapGesture {
                dismissKeyboard()
            }
        }
    }
}
