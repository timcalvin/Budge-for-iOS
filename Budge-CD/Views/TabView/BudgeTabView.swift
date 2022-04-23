//
//  BudgeTabView.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import SwiftUI

struct BudgeTabView: View {
    
    @State private var currentTab = Tabs.budgets
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.white)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.budgeLightGray)
    }
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            
            Budgets()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Budgets")
                }
                .tag(Tabs.budgets)
            
            Settings()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(Tabs.settings)
            
        }
        .accentColor(.budgeDarkGray)
        
    }
}

struct BudgeTabView_Previews: PreviewProvider {
    static var previews: some View {
        BudgeTabView()
    }
}
