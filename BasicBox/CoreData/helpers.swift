//
//  helpers.swift
//  OFTmain
//
//  Created by Lubor Kolacny on 17/9/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import Foundation
import CoreData

class  helper {

    let start = DispatchTime.now()
    var counter = 0
    var db_queues = [DispatchQueue]()
    let from = "2019-01-01T00:00:00.000Z"
    let granularities = "H1,D,M5"
    let instruments = "AUD_USD,EUR_USD,SPX500_USD,AUD_NZD,SPX500_USD,AUD_NZD,AU200_AUD,USD_JPY,GBP_CAD,BCO_USD,WTICO_USD,EUR_CHF,GBP_NZD,USD_CHF,CORN_USD,EUR_NOK,CHF_JPY,GBP_CHF,XAU_USD"
    var times: Int = 0
    func run_db() {
        for i in 1...5 {
            db_queues.append(DispatchQueue(label: "queue"+String(i)))
            print("queue"+String(i))
        }
        for granularity in granularities.split(separator: ",") {
            for instrument in instruments.split(separator: ",") {
                candlesLoaderInMain(queue: db_queues[times%5], from: skipDownloaded(from: from, instrument: String(instrument), granularity: String(granularity)), instrument: String(instrument), granularity: String(granularity), handler: handler)
                print(times%5,instrument,granularity)
                times += 1
            }
        }
    }
    
    static func storeCandles(moc:NSManagedObjectContext, candles:[Candle], granularity: String, instrument: String) throws {
        let cx = NSEntityDescription.insertNewObject(forEntityName: "CandleBA", into: moc) as! CandleBA_dto
        cx.instrument = instrument
        cx.granularity = granularity
        var cSet = Set<Candle_dto>()
        var from = Date() + (100 * 356 * 24 * 60 * 60)
        var to = Date() - (100 * 356 * 24 * 60 * 60)
        for c1 in candles {
            let c = NSEntityDescription.insertNewObject(forEntityName: "Candle", into: moc) as! Candle_dto
            c.a_c = Double(c1.ask.c)!
            c.a_h = Double(c1.ask.h)!
            c.a_o = Double(c1.ask.o)!
            c.a_l = Double(c1.ask.l)!
            c.b_c = Double(c1.bid.c)!
            c.b_h = Double(c1.bid.h)!
            c.b_o = Double(c1.bid.o)!
            c.b_l = Double(c1.bid.l)!
            c.complete = c1.complete
            c.time = c1.time_date
            c.c_hash = Int64((instrument + granularity).hash) + Int64(c1.time_date.timeIntervalSince1970*100000)
            cSet.insert(c)
            if (from > c.time!) { from = c.time! }
            if (to < c.time!) { to = c.time! }
        }
        cx.from = from
        cx.to = to
        cx.addToCandles(NSSet(set: cSet, copyItems: false))
        try moc.save()
    }

    func inSecondsFrom (time: DispatchTime) -> String {
        let t = (DispatchTime.now().uptimeNanoseconds - time.uptimeNanoseconds) / 1_000_000_000
        return String(t)
    }

    typealias HandlerLoadCandlesInMain = (CandlesBA)->String?
    let handler:HandlerLoadCandlesInMain = { (candles) in
        print(candles.candles.count)
        do {
            guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {exit(1)}
            let moc = try db().open(forEnv: "Live_" + candles.granularity, modelURL: url)
            let in_between1 = DispatchTime.now()
            print("From: \(candles.candles.first!.time)")
            try storeCandles(moc: moc, candles: candles.candles, granularity: candles.granularity, instrument: candles.instrument)
        } catch {
            print("Store failed!")
            return nil
        }
        if candles.candles.count < 5000 {
            print("We're done here!")
        } else if candles.candles.count == 5000 {
            return candles.candles.last!.time
        }
        return nil
    }

    func candlesLoaderInMain(queue: DispatchQueue, from: String, instrument: String, granularity: String, handler: @escaping HandlerLoadCandlesInMain) {
        queue.async {
            print(instrument, granularity)
            Network().candles(from: from, instrument: instrument, granularity: granularity, completionHandler: handler)
        }
    }

}
