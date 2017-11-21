//
//  TouchBarWindowController.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Cocoa

class TouchBarWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}

extension TouchBarWindowController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.customizationIdentifier = NSTouchBar.CustomizationIdentifier.coinTrackerBar
        touchBar.defaultItemIdentifiers = [.bitcoinItem, .ethereumItem, .dashItem]
        
        return touchBar
    }
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        let item = NSCustomTouchBarItem(identifier: identifier)
        
        switch identifier {
        case NSTouchBarItem.Identifier.bitcoinItem:
            item.view = NSTextField(labelWithString: "Bitcoin")
        case NSTouchBarItem.Identifier.ethereumItem:
            item.view = NSTextField(labelWithString: "Ethereum")
        default:
            item.view = NSTextField(labelWithString: "Default")
        }
        
        return item
    }
}
