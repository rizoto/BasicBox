//
//  Account.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 1/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation
import Combine

protocol AccountManager {
    mutating func createMarketOrderRequest(instrument: String, units: Decimal, price: Decimal) -> Bool
//    func processTick(flatPrice: FlatPrice) -> Void
}

struct Account {
    let hedgingEnabled: Bool
    private(set) var openPositions = [Trade]()
    private(set) var orders = [Order]()
}

extension Account: AccountManager {
    mutating func createMarketOrderRequest(instrument: String, units: Decimal, price: Decimal) -> Bool {
        orders.append(Order(instrument: instrument, units: units, requestPrice: price, orderType: .market, openTime: Date()))
        return true
    }
    var marketOrdersCount: Int {
        orders.filter({ o -> Bool in
            o.orderType == .market
            }).count
    }
    
    //MARK: Process Tick
    func subscribe(pub: TickCache) -> AnyCancellable {
        return pub.sink(receiveCompletion: { completion in
        }) { price in
            self.processTick(price: price)
        }
    }
    private func processTick(price: FlatPrice) {
        print(price)
    }
}
