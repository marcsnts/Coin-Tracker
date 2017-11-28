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
    var isPriceUp: Bool?
    
    enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case priceCAD = "price_cad"
        case priceEUR = "price_eur"
        case priceUSD = "price_usd"
        case isPriceUp = "non-existant"
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
        return Coin(name: self.name, symbol: self.symbol, priceCAD: self.priceCAD, priceEUR: self.priceEUR, priceUSD: self.priceUSD, isPriceUp: self.isPriceUp)
    }
    
    func isPriceGreaterThan(_ coin: Coin) -> Bool? {
        guard let ourPriceString = self.price(for: CoinTracker.sharedInstance.currency) else {
            print("Comparing coins failed, could not retrieve price for our coin")
            return nil
        }
        guard let otherPriceString = self.price(for: CoinTracker.sharedInstance.currency) else {
            print("Comparing coins failed, could not retrieve price for the other coin")
            return nil
        }
        guard let ourPrice = Double(ourPriceString), let otherPrice = Double(otherPriceString) else {
            print("Failed to convert strings to doubles when comparing prices: \(ourPriceString) and \(otherPriceString)")
            return nil
        }
        
        return ourPrice > otherPrice
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
