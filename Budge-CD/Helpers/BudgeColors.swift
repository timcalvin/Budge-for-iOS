//
//  BudgeColors.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import Foundation
import SwiftUI

struct BudgeColors {
    
    static var blue: Color {
        return Color(red: 0.282, green: 0.584, blue: 0.937)
    }
    
    static var teal: Color {
        return Color(red: 0.29, green: 0.914, blue: 0.929)
    }
    
    static var darkGray: Color {
        return Color(red: 0.169, green: 0.173, blue: 0.176)
    }
    
    static var lightGray: Color {
        return Color(red: 0.78, green: 0.804, blue: 0.827)
    }
    
    static var white: Color {
        return Color(red: 1.0, green: 1.0, blue: 1.0)
    }
    
    static var black: Color {
        return Color(red: 0.0, green: 0.0, blue: 0.0)
    }
    
    static var bgGradient: LinearGradient {
        return LinearGradient(colors: [self.blue, self.teal], startPoint: .top, endPoint: .bottom)
    }
    
}
