//
//  DataManager.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 19/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Combine
import SwiftUI

enum AccountType {
    case live
    case demo
}

class DataManager: ObservableObject {
    @Published var activeAccount = AccountType.live
    @Published var instruments: Instruments = Instruments(instruments: Array<Instruments.Instrument>())
    init() {
        getInstruments()
    }
    internal var set = Set<AnyCancellable>()
    func getInstruments() {
        let sub = Network().instruments().assign(to: \DataManager.instruments, on: self)
        sub.store(in: &set)
    }
}

