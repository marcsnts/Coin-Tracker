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
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let seperator = NSMenuItem.separator()
    let placeholderItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    var coinMenuItems = [NSMenuItem]()
    let currencyMenu = NSMenu(title: "Currency")
    let cadMenuItem = NSMenuItem(title: "CAD", action: #selector(changeCurrency(_:)), keyEquivalent: "CAD")
    let usdMenuItem = NSMenuItem(title: "USD", action: #selector(changeCurrency(_:)), keyEquivalent: "USD")
    let eurMenuItem = NSMenuItem(title: "EUR", action: #selector(changeCurrency(_:)), keyEquivalent: "EUR")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        setupMenu()
        NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(refreshTwo), userInfo: nil, repeats: true)
        refreshTwo()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func quitApplication() {
        NSApplication.shared.terminate(nil)
    }
    
    private func setupMenu() {
        let currencyMenuItem = NSMenuItem(title: "Currencies", action: nil, keyEquivalent: "")
        statusItem.menu = {
            let menu = NSMenu()
            menu.addItem(self.placeholderItem)
            menu.addItem(self.seperator)
            
            menu.addItem(currencyMenuItem)
            menu.setSubmenu(currencyMenu, for: currencyMenuItem)
            
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApplication), keyEquivalent: "quit"))
            menu.delegate = NSApplication.shared.delegate as! AppDelegate
    
            return menu
        }()
        
        for item in [usdMenuItem, cadMenuItem, eurMenuItem] {
            currencyMenu.addItem(item)
        }
        currencyMenu.delegate = self
        statusItem.menu?.setSubmenu(currencyMenu, for: currencyMenuItem)
    }
    
    @objc func changeCurrency(_ sender: Any?) {
        guard let chosenCurrency = sender as? NSMenuItem else { return }
        
        switch chosenCurrency {
        case cadMenuItem:
            CoinTracker.sharedInstance.currency = .cad
        case usdMenuItem:
            CoinTracker.sharedInstance.currency = .usd
        case eurMenuItem:
            CoinTracker.sharedInstance.currency = .euro
        default:
            break
        }
    }
}

extension AppDelegate: NSMenuDelegate {
    func menuWillOpen(_ menu: NSMenu) {
        guard menu == statusItem.menu else { return }
        
        refreshDropDown(menu: menu)
    }
    
    private func refreshDropDown(menu: NSMenu) {
        guard menu != self.currencyMenu else { return }
        DispatchQueue.main.async {
            if menu.items.contains(self.placeholderItem) {
                menu.removeItem(self.placeholderItem)
            }
            
            print(self.coinMenuItems.count)
            for item in self.coinMenuItems {
                if menu.items.contains(item) {
                    menu.removeItem(item)
                }
            }
        }
        
        CoinAPI.getCoins(currency: CoinTracker.sharedInstance.currency) { coins in
            let filteredCoins = coins.filter { coin in
                return Symbol.all.map{$0.rawValue}.contains(coin.symbol)
            }
            
            self.coinMenuItems = filteredCoins.map {
                let menuItem = NSMenuItem(title: "\($0.symbol) - $\($0.price(for: CoinTracker.sharedInstance.currency)!)", action: #selector(self.toggleMenuItemCoin(_:)), keyEquivalent: "")
                menuItem.state = CoinTracker.sharedInstance.menuBarSymbols.map({$0.rawValue}).contains($0.symbol) ? .on : .off
                return menuItem
            }
            
            let seperatorIndex = menu.index(of: self.seperator)
            for item in self.coinMenuItems.reversed() {
                DispatchQueue.main.async {
                    menu.insertItem(item, at: seperatorIndex - 1 < 0 ? 0 : seperatorIndex - 1)
                }
            }
        }
    }
    
    @objc private func toggleMenuItemCoin(_ sender: Any?) {
        guard let menuItem = sender as? NSMenuItem else { return }
        
        menuItem.state = menuItem.state == .on ? .off : .on
        
        if menuItem.state == .on {
            CoinTracker.sharedInstance.menuBarSymbols = CoinTracker.sharedInstance.menuBarSymbols.filter({
                return !menuItem.title.contains($0.rawValue)
            })
            menuItem.state = .off
        } else if menuItem.state == .off {
            menuItem.state = .on
            // Add to CoinTracker.sharedInstance.menuBarSymbols
        }
        
    }
    
    @objc private func refreshTwo() {
        CoinAPI.getCoins(currency: CoinTracker.sharedInstance.currency) { coins in
            let supportedCoins = coins.filter { coin in
                return Symbol.all.map{$0.rawValue}.contains(coin.symbol)
            }
            
            CoinTracker.sharedInstance.coins = supportedCoins
            let oldCoins = CoinTracker.sharedInstance.getMenuBarCoins()
            var newCoins = oldCoins.map({$0.makeCopy()})
            
            // Populate `isPriceUp` property in newCoins
            for i in 0..<newCoins.count {
                if let oldCoin = oldCoins.filter({$0.symbol == newCoins[i].symbol}).first {
                    newCoins[i].isPriceUp = newCoins[i].isPriceGreaterThan(oldCoin)
                }
            }
            
            DispatchQueue.main.async {
                self.updateMenuBarTitle(with: newCoins)
            }
        }
    }
    
    private func updateMenuBarTitle(with coins: [Coin]) {
        // given an array of coins, construct a string that is in the format of "(SYMBOL) (CURRENCY)$(PRICE)"
        //                           where (CURRENCY)$(PRICE) is green if `isPriceUp` is true, red otherwise
        let currency = CoinTracker.sharedInstance.currency
        
        let newStrings = coins.map({ coin -> NSMutableAttributedString in
            let priceString = "$\(coin.price(for: currency)!)"
            let newString = "\(coin.symbol) \(priceString)"
            let attrString = NSMutableAttributedString(string: newString)

            if let isPriceUp = coin.isPriceUp, let range = newString.range(of: priceString)?.nsRange {
                attrString.addAttribute(.foregroundColor, value: isPriceUp ? NSColor.green : NSColor.red, range: range)
            }
            
            return attrString
        })
        
        if !newStrings.isEmpty {
            var menuBarTitle = newStrings[0]
            for i in 1..<newStrings.count {
                menuBarTitle.append(NSAttributedString(string: " "))
                menuBarTitle.append(newStrings[i])
            }
            self.statusItem.attributedTitle = menuBarTitle
        }
    }
    
}
