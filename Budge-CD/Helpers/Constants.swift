//
//  Constants.swift
//  Budge-CD
//
//  Created by Timothy Bryant on 4/19/22.
//

import Foundation

struct Constants {
    
    // Major, Feature, Bug, Build
    static let versionNumber: String = "1.0.1 (10)"
    
    // Currency Format
    static var currencyFormat: FloatingPointFormatStyle<Double>.Currency {
        return .currency(code: Locale.current.currencyCode ?? "USD")
    }
    
}
