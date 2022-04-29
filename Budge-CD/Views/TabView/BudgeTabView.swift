//
//  BudgeTabView.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import SwiftUI

struct BudgeTabView: View {
    
    @StateObject var vm = ViewModel()
    
    @State private var currentTab = Tabs.budgets
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(.white)
        UITabBar.appearance().unselectedItemTintColor = UIColor(.budgeLightGray)
    }
    
    var body: some View {
        
        TabView(selection: $currentTab) {
            
            Budgets(vm: vm)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Budgets")
                }
                .tag(Tabs.budgets)
            
            Settings(vm: vm)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(Tabs.settings)
            
        }
        .accentColor(.budgeDarkGray)
        .shadow(color: .black, radius: 10)
    }
}

struct BudgeTabView_Previews: PreviewProvider {
    static var previews: some View {
        BudgeTabView()
    }
}
