//
//  DismissKeyboard.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import SwiftUI

extension View {
    
    /// Dismisses the keyboard when the user taps ouside the textfield.
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
