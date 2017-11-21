//
//  Currency.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation

enum Currency: String {
    case usd = "USD"
    case cad = "CAD"
    case euro = "EUR"
    
    var priceKey: String {
        // ex: price_cad
        return "price_" + self.rawValue.lowercased()
    }
}
