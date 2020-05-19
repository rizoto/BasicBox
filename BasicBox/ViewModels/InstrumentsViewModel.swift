//
//  InstrumentsViewModel.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Combine
import SwiftUI

class InstrumentsViewModel {
    internal var set = Set<AnyCancellable>()
    init(_ loaded: inout Bool) {
        getInstruments(&loaded)
    }
    var instruments = Instruments(instruments: Array<Instruments.Instrument>())
    func getInstruments(_ loaded: inout Bool) {
        let sub = Network().instruments().assign(to: \InstrumentsViewModel.instruments, on: self)
        sub.store(in: &set)
        loaded = true
    }
}
