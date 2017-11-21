//
//  AppDelegate.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: NSWindow!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let seperator = NSMenuItem.separator()
    let placeholderItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    var coinMenuItems = [NSMenuItem]()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func openPreferences() {
//        let vc = PreferencesViewController(nibName: NSNib.Name.init(rawValue: "PreferencesViewController"), bundle: Bundle.main)
//        let window = NSWindow(contentViewController: vc)
//        window.makeKey()
    }
    
    @objc func quitApplication() {
        NSApplication.shared.terminate(nil)
    }
    
    private func setupMenu() {
        statusItem.button?.image = NSImage(named: NSImage.Name.menuIcon)
        statusItem.menu = {
            let menu = NSMenu()
            menu.addItem(self.placeholderItem)
            menu.addItem(self.seperator)
            menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(openPreferences), keyEquivalent: "preferences"))
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApplication), keyEquivalent: "quit"))
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
        DispatchQueue.main.async {
            if menu.items.contains(self.placeholderItem) {
                menu.removeItem(self.placeholderItem)
            }
            
            for item in self.coinMenuItems {
                menu.removeItem(item)
            }
        }
        
        
        CoinAPI.getCoins(currency: .usd) { coins in
            let filteredCoins = coins.filter { coin in
                return Symbol.all.map{$0.rawValue}.contains(coin.symbol)
            }
            
            self.coinMenuItems = filteredCoins.map{NSMenuItem(title: "\($0.symbol) - $\($0.priceUSD!)", action: nil, keyEquivalent: "")}
            
            let seperatorIndex = menu.index(of: self.seperator)
            for item in self.coinMenuItems.reversed() {
                DispatchQueue.main.async {
                    menu.insertItem(item, at: seperatorIndex - 1 < 0 ? 0 : seperatorIndex - 1)
                }
            }
        }
    }
}
