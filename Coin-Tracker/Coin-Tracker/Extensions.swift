//
//  Extensions.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage.Name {
    static let menuIcon = NSImage.Name("bitcoin-logo")
}

extension NSTouchBarItem.Identifier {
    static let bitcoinItem = NSTouchBarItem.Identifier("com.marcsantos.BitcoinItem")
    static let ethereumItem = NSTouchBarItem.Identifier("com.marcsantos.EthereumItem")
    static let dashItem = NSTouchBarItem.Identifier("com.marcsantos.DashItem")
}

extension NSTouchBar.CustomizationIdentifier {
    static let coinTrackerBar = NSTouchBar.CustomizationIdentifier("com.marcsantos.CoinTrackerTouchBar")
}
