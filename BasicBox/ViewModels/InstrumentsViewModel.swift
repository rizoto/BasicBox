//
//  InstrumentsViewModel.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 9/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Combine
import SwiftUI

final class InstrumentsViewModel: ObservableObject {
    @Published var instruments = ["AUD_USD","EUR_USD","SPX500_USD","SPX500_USD","AUD_NZD","AU200_AUD","USD_JPY","GBP_CAD","BCO_USD","WTICO_USD","EUR_CHF","GBP_NZD","USD_CHF","CORN_USD","EUR_NOK","CHF_JPY","GBP_CHF","XAU_USD"].sorted()
}
