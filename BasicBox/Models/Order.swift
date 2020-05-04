//
//  Order.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation

enum OrderType {
    case market
    case limit
}

struct Order {
    let instrument: String
    let units: Decimal
    let requestPrice: Decimal
    let orderType: OrderType
    var openTime: Date
}

