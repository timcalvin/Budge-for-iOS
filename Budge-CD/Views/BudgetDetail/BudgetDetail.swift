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
    
    // Budget
    @State var budget: Budget
    
    var body: some View {
        Text(budget.name ?? "")
    }
}
