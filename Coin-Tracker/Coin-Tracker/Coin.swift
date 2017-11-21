//
//  Coin.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation

struct Coin: Codable {
    let name: String
    let symbol: String
    var priceCAD: String?
    var priceEUR: String?
    var priceUSD: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case priceCAD = "price_cad"
        case priceEUR = "price_eur"
        case priceUSD = "price_usd"
    }
    
    func price(for currency: Currency) -> String? {
        switch currency {
        case .cad:
            return self.priceCAD
        case .usd:
            return self.priceUSD
        case .euro:
            return self.priceEUR
        }
    }
    
    func makeCopy() -> Coin {
        return Coin(name: self.name, symbol: self.symbol, priceCAD: self.priceCAD, priceEUR: self.priceEUR, priceUSD: self.priceUSD)
    }
}

enum Symbol: String {
    case ethereum = "ETH"
    case bitcoin = "BTC"
    case bitcoinCash = "BCH"
    case ripple = "XRP"
    case litecoin = "LTC"
    case dash = "DASH"
    
    static let all: [Symbol] = [.ethereum, .bitcoin, .bitcoinCash, .ripple, .litecoin, .dash]
}
