//
//  Trade.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation

enum TradeState {
    case open
    case closed
}

struct Trade {
    let instrument: String
    let units: Decimal // + long; - short
    let openTime: Date
    var state: TradeState
}
