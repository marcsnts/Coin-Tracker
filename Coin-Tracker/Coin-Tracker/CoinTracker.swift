//
//  CoinTracker.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation

class CoinTracker {
    static let sharedInstance = CoinTracker()
    var coins: [Coin]
    var currency: Currency
    var menuBarSymbols: [Symbol]
    
    private init() {
        self.coins = [Coin]()
        self.currency = Currency.usd
        self.menuBarSymbols = [.bitcoin, .ethereum]
    }
    
    func getMenuBarCoins() -> [Coin] {
        return self.coins.filter({ coin in
            return self.menuBarSymbols.map({$0.rawValue}).contains(coin.symbol)
        })
    }
    
    func addMenuBarSymbol() {
        
    }
        
}
