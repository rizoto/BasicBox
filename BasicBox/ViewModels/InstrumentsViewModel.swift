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
    @Published var instruments = ["XAU_EUR","UK100_GBP","XCU_USD","DE30_EUR","EUR_ZAR","NAS100_USD","EUR_PLN","XAG_GBP","BCO_USD","AUD_JPY","USD_CAD","XAG_NZD","USD_NOK","CAD_SGD","HKD_JPY","NZD_JPY","FR40_EUR","USD_HUF","CHF_ZAR","EUR_CZK","AUD_HKD","GBP_NZD","NZD_HKD","NZD_CHF","XAU_CHF","USD_SAR","GBP_CAD","CAD_JPY","EU50_EUR","XPT_USD","XAG_CHF","USB10Y_USD","ZAR_JPY","NZD_SGD","GBP_ZAR","SOYBN_USD","XAG_EUR","NZD_CAD","XAG_SGD","XAU_SGD","CN50_USD","USD_INR","CAD_HKD","SGD_CHF","CAD_CHF","AUD_SGD","EUR_NOK","AU200_AUD","EUR_CHF","SG30_SGD","USB30Y_USD","XAG_CAD","GBP_USD","USD_MXN","USD_CHF","XAU_USD","AUD_CHF","EUR_DKK","CORN_USD","AUD_USD","NL25_EUR","BTC_USD","WTICO_USD","DE10YB_EUR","CHF_HKD","USD_THB","GBP_CHF","TRY_JPY","XAU_XAG","XAU_NZD","AUD_CAD","SGD_JPY","EUR_NZD","USD_HKD","EUR_AUD","XAG_JPY","UK10YB_GBP","XAG_USD","XAU_GBP","USD_DKK","CHF_JPY","EUR_SGD","USD_SGD","EUR_SEK","USD_JPY","EUR_TRY","USD_CZK","GBP_AUD","USD_PLN","EUR_USD","SPX500_USD","AUD_NZD","SGD_HKD","JP225_USD","EUR_HUF","XAG_HKD","XAG_AUD","NZD_USD","XAU_CAD","MBTC_USD","USD_CNH","IN50_USD","XAU_AUD","USB02Y_USD","EUR_HKD","XAU_JPY","TWIX_USD","EUR_JPY","WHEAT_USD","GBP_PLN","GBP_JPY","USD_TRY","HK33_HKD","EUR_CAD","USD_SEK","GBP_SGD","XAU_HKD","EUR_GBP","US2000_USD","XPD_USD","SUGAR_USD","US30_USD","GBP_HKD","USB05Y_USD","NATGAS_USD","USD_ZAR"].sorted()
}