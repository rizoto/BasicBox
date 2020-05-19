//
//  Network.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 10/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation
import Combine

class Network: NSObject, URLSessionDataDelegate {
    let token:String
    let account:String
    let baseURL = "https://api-fxtrade.oanda.com/v3/"
    override init() {
        let accounts = TokenManager().fetchAccounts()
        let tokens = TokenManager().fetchTokens()
        token = tokens.1
        account = accounts.1
    }
    //MARK:Candles
    func candles(from: String, instrument: String, granularity: String, completionHandler: @escaping (CandlesBA) -> String?) {
        let sharedSession = URLSession.shared
        if let url = URL(string: baseURL + "instruments/\(instrument)/candles?from=\(from)&count=5000&price=BA&granularity=\(granularity)") {
            // Create Request
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            // Create Data Task
            let dataTask = sharedSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let data = data {
                                    do{
                                        let decoder = JSONDecoder()
                                        let candles = try decoder.decode(CandlesBA.self, from:data)
                                        if let another = completionHandler(candles) {
                                            self.candles(from: another, instrument: instrument, granularity: granularity, completionHandler: completionHandler)
                                        }
                                    } catch let error {
                                        print(error)
                                    }
                }
            })
            dataTask.resume()
        }
    }
    //MARK:Instruments
    func instruments() -> AnyPublisher<Instruments,Never> {
        var pub = Just(Instruments(instruments: [])).eraseToAnyPublisher()
        if let url = URL(string: baseURL + "accounts/\(account)/instruments") {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            pub = URLSession.shared.dataTaskPublisher(for: request)
            .map { input -> Data in
                print(String(decoding: input.data, as: UTF8.self))
                return input.data }
            .decode(type: Instruments.self, decoder: JSONDecoder())
            .catch { err in
                Just(Instruments(instruments: []))
            }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        }
        return pub
    }
}
