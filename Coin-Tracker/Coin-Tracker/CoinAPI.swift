//
//  CoinAPI.swift
//  Coin-Tracker
//
//  Created by Marc on 2017-11-21.
//  Copyright © 2017 Marc Santos. All rights reserved.
//

import Foundation

class CoinAPI {
    static func getCoins(currency: Currency, completion: @escaping (([Coin]) ->Void)) {
        let urlComponents: URLComponents = {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.coinmarketcap.com"
            components.path = "/v1/ticker/"
            let query = URLQueryItem(name: "convert", value: currency.rawValue)
            components.queryItems = [query]
            return components
        }()
        
        guard let url = urlComponents.url else {
            print("GET coins failed url could not be created")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession(configuration: .default).dataTask(with: request) { responseData, response, responseError in
            guard let jsonData = responseData else {
                if let error = responseError {
                    print(error.localizedDescription)
                }
                return
            }
            guard let coins = try? JSONDecoder().decode(Array<Coin>.self, from: jsonData) else {
                print("Could not decode json response")
                return
            }
            
            let roundedPrice: (String?) -> String? = { price in
                guard let price = price else { return nil }
                return Double(price)?.roundedString
            }
            
            let roundedCoins = coins.map { coin -> Coin in
                var newCoin = coin.makeCopy()
                newCoin.priceCAD = roundedPrice(coin.priceCAD)
                newCoin.priceUSD = roundedPrice(coin.priceUSD)
                newCoin.priceEUR = roundedPrice(coin.priceEUR)
                return newCoin
            }
            
            completion(roundedCoins)
        }.resume()
    }
}
