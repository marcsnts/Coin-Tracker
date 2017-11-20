//
//  AppDelegate.swift
//  Coin Tracker
//
//  Created by Marc on 2017-11-20.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var seperatorIndex: Int?
    var coinMenuItems = [NSMenuItem]()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func buttonTapped(_ sender: Any?) {
        print("yo")
    }

    private func setupMenu() {
        statusItem.button?.image = NSImage(named: NSImage.Name.menuIcon)
        statusItem.menu = {
            let menu = NSMenu()
            let seperator = NSMenuItem.separator()
            menu.addItem(seperator)
            self.seperatorIndex = menu.index(of: seperator)
            menu.addItem(NSMenuItem(title: "Preferences...", action: nil, keyEquivalent: "preferences"))
            menu.addItem(NSMenuItem(title: "Quit", action: nil, keyEquivalent: "quit"))
            menu.delegate = NSApplication.shared.delegate as! AppDelegate
            return menu
        }()
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        guard menu == statusItem.menu else { return }
        
        refresh(menu: menu)
    }
    
    private func refresh(menu: NSMenu) {
        guard let seperatorIndex = self.seperatorIndex else { return }
        
        DispatchQueue.main.async {
            for item in self.coinMenuItems {
                menu.removeItem(item)
            }
        }
        CoinAPI.getCoins(currency: .usd) { coins in
            let filteredCoins = coins.filter { coin in
                 return Symbol.all.map{$0.rawValue}.contains(coin.symbol)
            }
            
            self.coinMenuItems = filteredCoins.map{NSMenuItem(title: "\($0.symbol) - $\($0.priceUSD!)", action: nil, keyEquivalent: "")}
            
            for item in self.coinMenuItems.reversed() {
                DispatchQueue.main.async {
                    menu.insertItem(item, at: seperatorIndex - 1 < 0 ? 0 : seperatorIndex - 1)
                }
            }
        }
    }
}

