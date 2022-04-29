//
//  LaunchView.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/18/22.
//

import SwiftUI

struct LaunchView: View {
    
    init() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(.budgeDarkGray)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(.budgeDarkGray)]
        navBarAppearance.tintColor = UIColor(.budgeDarkGray)
    }   
    
    var body: some View {
        BudgeTabView()
            .preferredColorScheme(.light)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
