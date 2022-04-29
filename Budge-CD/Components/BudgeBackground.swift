//
//  BudgeBackground.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/29/22.
//

import SwiftUI

struct BudgeBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.budgeBlue)
            .ignoresSafeArea()
    }
}

struct BudgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BudgeBackground()
    }
}
