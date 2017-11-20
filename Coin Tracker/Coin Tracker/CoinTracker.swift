//
//  CoinTracker.swift
//  Coin Tracker
//
//  Created by Marc on 2017-11-20.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation

class CoinTracker {
    static let sharedInstance = CoinTracker()
    var coins: [Coin]
    var currency: Currency
    
    private init() {
        self.coins = [Coin]()
        self.currency = Currency.usd
    }
}
