//
//  ComponentLabel.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/25/22.
//

import SwiftUI

struct ComponentLabel: View {
    
    let image: String
    
    var body: some View {
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .frame(width: 26, height: 26)
    }
}
