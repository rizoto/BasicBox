//
//  Trader.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation
import Combine

protocol Strategy {
    var ticks: AnyPublisher <FlatPrice, Error> {get set}
    var instrument: String {get set}
    var endOf: () -> Void {get set}
    func tick(price: FlatPrice, account: Account) -> Account
}

protocol Trading {
    func createMarketOrderRequest(instrument: String, units: Double, price: Double) -> Bool
    func runStrategy(strategy: Strategy)
}

class Trader {
    var account: Account
    var set = Set<AnyCancellable>()
    init(account: Account) {
        self.account = account
    }
}

struct BasicStrategy4UnitTest: Strategy {
    internal var instrument: String
    internal var endOf: () -> Void
    internal var ticks: AnyPublisher<FlatPrice, Error>
    
    func tick(price: FlatPrice, account: Account) -> Account {
        _ = account.createMarketOrderRequest(instrument: price.instrument, units: 1, price: Double(price.price))
        return account
    }
}

extension Trader: Trading {
    func createMarketOrderRequest(instrument: String, units: Double, price: Double) -> Bool {
        account.createMarketOrderRequest(instrument: instrument, units: units, price: price)
    }
    
    func runStrategy(strategy: Strategy) {
        let sub = strategy.ticks
            .filter { price -> Bool in
                price.instrument == strategy.instrument && price.tradeable }
            .reduce(account, { (account, price) -> Account in
                strategy.tick(price: price, account: account)
            }).sink(receiveCompletion: {completion in
                switch completion {
                case .failure:
                    break
                case .finished:
                    strategy.endOf()
                }
            }) { account in
                self.account = account}
        sub.store(in: &set)
        //replaceError(with: account).assign(to: \Trader.account, on: self)
    }
}
