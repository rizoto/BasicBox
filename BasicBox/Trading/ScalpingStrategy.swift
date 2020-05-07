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
    internal var ticks: AnyPublisher<FlatPrice, Error>
    
    init(instrument: String, endOf: @escaping () -> Void, ticks: AnyPublisher<FlatPrice, Error>) {
        self.instrument = instrument
        self.endOf = endOf
        self.ticks = ticks
    }
    
    func tick(price: FlatPrice, account: Account) -> Account {
        
        return account
    }
}
