//
//  ScalpingStrategy.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 7/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation
import Combine

class ScalpingStrategy: Strategy {
    internal var instrument: String
    internal var endOf: () -> Void
    
    var mmin = 1.0
    var mmax = 0.0
    
    let dateFormatter = DateFormatter()
    
    init(instrument: String, endOf: @escaping () -> Void) {
        self.instrument = instrument
        self.endOf = endOf
        dateFormatter.timeZone = .autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    func tick(price: FlatPrice, account: Account) -> Account {
        if price.bid_ask {
            if mmin <= price.price || price.price <= mmax {
                print(price.price, mmin, mmax, dateFormatter.string(from: Date(timeIntervalSince1970: price.time)))
            }
            mmin = (mmin + Double.minimum(mmin, price.price)) / 2.0
            mmax = (mmax + Double.maximum(mmax, price.price)) / 2.0
        }
        return account
    }
}
