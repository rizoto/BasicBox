//
//  Trader.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation

protocol Trading {
    mutating func createMarketOrderRequest(instrument: String, units: Decimal, price: Decimal) -> Bool
}

struct Trader {
    var account: Account
}

extension Trader: Trading {
    mutating func createMarketOrderRequest(instrument: String, units: Decimal, price: Decimal) -> Bool {
        account.createMarketOrderRequest(instrument: instrument, units: units, price: price)
    }
}
