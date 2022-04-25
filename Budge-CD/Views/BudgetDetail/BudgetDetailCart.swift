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
        let color = vm.iconColor(fromBudgetColor: budget.themeColor ?? "default")
        return color == .white ? .budgeBlue : color
    }
    
    var body: some View {
        Text(budget.name ?? "")
    }
}
