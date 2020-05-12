//
//  DetailViewViewModel.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 11/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import SwiftUI
import Combine

final class DetailViewViewModel: ObservableObject {
    @Published var instrument = ""
    var candles = [CandleD]()
    var from = ""

    init() {
    }
    func fetchInstrument(instrument: String) {
        do {
            let granularity = "H1"
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
    }
    var graphDataSource: [Candle4Graph] {
        return candles.suffix(500).map { candleD -> Candle4Graph in
            Candle4Graph(o: CGFloat(candleD.ask.o), c: CGFloat(candleD.ask.c), l: CGFloat(candleD.ask.l), h: CGFloat(candleD.ask.h))
        }
    }
}
