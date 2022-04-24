//
//  BudgetListButton.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/21/22.
//

import SwiftUI

struct BudgetListButton: View {
    
    @ObservedObject var vm: ViewModel
    let budget: Budget?
    let frameSize: CGFloat = 90
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .foregroundColor(vm.iconColor(fromBudgetColor: budget?.themeColor ?? "default"))
                    .frame(width: frameSize, height: frameSize)
                Image(systemName: budget?.icon ?? "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: frameSize/2, height: frameSize/2)
                    .foregroundColor(budget == nil ? .budgeBlue : (budget?.themeColor == "default" ? .budgeBlue : .white))
            }
            .padding(.bottom, 10)
            Text(budget?.name ?? (vm.budgets.count > 0 ? "New Budget" : "Oh no, this looks empty!\nLet's add your first list."))
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
    }
}
