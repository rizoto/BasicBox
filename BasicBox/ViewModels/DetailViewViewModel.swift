//
//  DetailViewViewModel.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 11/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI
import Combine
 
let magic = 500
final class DetailViewViewModel: ObservableObject {
    @Published var instrument = ""
    var candles = [CandleD]()
    var from = ""
    
   
    var inOpen = Array<Double>()
    var inHigh = Array<Double>()
    var inLow = Array<Double>()
    var inClose = Array<Double>()

    init() {
    }
    func fetchInstrument(instrument: String) {
        do {
            let granularity = "M5"
            guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return}
            let moc = try db().open(forEnv: "Live_" + granularity, modelURL: url)
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CandleBA")
            fetch.predicate = NSPredicate(format: "granularity == %@ AND instrument == %@", granularity, instrument)
            let cBA1 = try moc.fetch(fetch) as! [CandleBA_dto]
            self.from = cBA1.first?.from?.toString ?? "Error"
            if let first = cBA1.first {
                let c = (first.candles as! Set<Candle_dto>).sorted { (ca, cb) -> Bool in
                    ca.time! < cb.time!
                }
                candles = c.map { cx -> CandleD in
                    let bid = CandleD.BidAsk(o: cx.b_o, h: cx.b_h, l: cx.b_l, c: cx.b_c)
                    let ask = CandleD.BidAsk(o: cx.a_o, h: cx.a_h, l: cx.a_l, c: cx.a_c)
                    return CandleD(complete: cx.complete, volume: Int(cx.volume), time: cx.time!, bid: bid, ask: ask)
                }
            }
        } catch {
            print("DetailViewViewModel fetchInstrument error")
        }
        self.instrument = instrument
        patternCdl2Crows()
    }
    var graphDataSource: [Candle4Graph] {
        return candles.suffix(magic).map { candleD -> Candle4Graph in
            return Candle4Graph(o: CGFloat(candleD.ask.o), c: CGFloat(candleD.ask.c), l: CGFloat(candleD.ask.l), h: CGFloat(candleD.ask.h))
        }
    }
    func useTALib() {
        var res = TA_Initialize();
        if(res != TA_SUCCESS)
           {
               print("Error TA_Initialize:", res);
               return
           }

        let data = [105.68, 93.74, 92.72, 90.52, 95.22, 100.35, 97.92, 98.83, 95.33,
        93.4, 95.89, 96.68, 98.78, 98.66, 104.21, 107.48, 108.18, 109.36,
        106.94, 107.73, 103.13, 114.92, 112.71, 113.05, 114.06, 117.63,
        116.6, 113.72, 108.84, 108.43, 110.06, 111.79, 109.9, 113.95,
        115.97, 116.52, 115.82, 117.91, 119.04, 120, 121.95, 129.08,
        132.12, 135.72, 136.66, 139.78, 139.14, 139.99, 140.64, 143.66]

        let data_size:Int32 = Int32(data.count)
        let res_size = data_size - TA_MACD_Lookback(12, 26, 9)

        var outMACD = Array<Double>(repeating: 0.0, count:Int(res_size))
        var outMACDSignal = Array<Double>(repeating: 0.0, count:Int(res_size))
        var outMACDHist = Array<Double>(repeating: 0.0, count:Int(res_size))

        var outBegIdx:Int32 = 0
        var outNbElement:Int32 = 0

        res = TA_MACD(0, data_size-1,                       // data range
                      data,                                 // data pointer
                      12, 26, 9,                            // TA Func specific args
                      &outBegIdx, &outNbElement,            // relative index and size of results
                      &outMACD, &outMACDSignal, &outMACDHist); // arrays of results

        if (res == TA_SUCCESS) {
            for i in 0...outNbElement-1 {
                print("Result for day \(outBegIdx+i) outMACD: \(outMACD[Int(i)]) outMACDSignal: \(outMACDSignal[Int(i)]) outMACDHist: \(outMACDHist[Int(i)])")
               }
        } else {
               print("Error TA_MACD:", res);
        }

        res = TA_Shutdown();
        if(res != TA_SUCCESS)
        {
            print("Error TA_Shutdown:", res)
        }
    }
    
    func patternCdl2Crows() {
        for i in 0...candles.count-1 {
            inOpen.append(candles[i].ask.o)
            inLow.append(candles[i].ask.l)
            inHigh.append(candles[i].ask.h)
            inClose.append(candles[i].ask.c)
        }
        var res = TA_Initialize();
        if(res != TA_SUCCESS)
       {
           print("Error TA_Initialize:", res);
           return
       }
        var outBegIdx:Int32 = 0
        var outNbElement:Int32 = 0
        var outInteger = Array<Int32>(repeating: 0, count:Int(magic)-Int(TA_CDL3WHITESOLDIERS_Lookback()))
        res = TA_CDL3WHITESOLDIERS(0, Int32(magic-1), inOpen, inHigh, inLow, inClose, &outBegIdx, &outNbElement, &outInteger)
        print(TA_CDL3WHITESOLDIERS_Lookback())
        if (res == TA_SUCCESS) {
            for i in 0...outNbElement-1 {
                if outInteger[Int(i)] != 0 {
                    print(outInteger[Int(i)])
                }
               }
        } else {
               print("Error TA_MACD:", res);
        }
        res = TA_Shutdown();
        if(res != TA_SUCCESS)
        {
            print("Error TA_Shutdown:", res)
        }
    }
}
