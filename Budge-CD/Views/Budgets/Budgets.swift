//
//  Budgets.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

// TODO: - Add sort options

import SwiftUI

struct Budgets: View {
    
    // Core Data reference
    @StateObject var vm = ViewModel()
    
    // State properties
    @State private var showingBudgetDetail = false
    @State private var showingSortOptions = false
    
    // Layout properties
    private var layout = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                
                LinearGradient(colors: [.budgeBlue, .budgeTeal], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                if vm.budgets.count > 0 {
                    
                    ScrollView(showsIndicators: false) {
                        
                    }
                    
                } else {
                    
                    // Budgets do not exist
                    VStack {
                        Spacer()
                        Button {
                            showingBudgetDetail = true
                        } label: {
                            BudgetListButton(vm: vm, budget: nil, frameSize: 128)
                        }
                        .sheet(isPresented: $showingBudgetDetail) {
                            BudgetSetup(vm: vm, budget: nil)
                        }
                        Spacer()
                    }
                    
                }
            }
        }
    }
}

struct Budgets_Previews: PreviewProvider {
    static var previews: some View {
        Budgets()
    }
}
