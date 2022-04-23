//
//  BudgeButton.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/22/22.
//

import Foundation
import SwiftUI

struct BudgeButton: ButtonStyle {
    
    var buttonColor: Color = .white
    var textColor: Color = .blue
    
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            Capsule()
                .foregroundColor(buttonColor)
                .frame(height: 44)
                .shadow(radius: 5)
            configuration.label
                .font(.headline)
                .foregroundColor(textColor)
        }
        .opacity(configuration.isPressed ? 0.2 : 1.0)
        .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
    }
    
}
