//
//  DbTests.swift
//  OFTTests
//
//  Created by Lubor Kolacny on 14/9/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import XCTest
@testable import BasicBox

func storeCandles(moc:NSManagedObjectContext, candles:[Candle], accountType: String, granularity: String, instrument: String) throws {
    //            try moc.save()
//    let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CandleBA")
//    fetch.predicate = NSPredicate(format: "granularity == %@ AND instrument == %@", granularity, instrument)
//    let cBA1 = try moc.fetch(fetch) as! [CandleBA_dto]
//
//    for c1 in candles {
//        let c = NSEntityDescription.insertNewObject(forEntityName: "Candle", into: moc) as! Candle_dto
//        c.a_c = Double(c1.ask.c)!
//        c.a_h = Double(c1.ask.h)!
//        c.a_o = Double(c1.ask.o)!
//        c.a_l = Double(c1.ask.l)!
//        c.b_c = Double(c1.bid.c)!
//        c.b_h = Double(c1.bid.h)!
//        c.b_o = Double(c1.bid.o)!
//        c.b_l = Double(c1.bid.l)!
//        c.complete = c1.complete
//        c.time = c1.time_date
//        c.candleBA = cBA1.first
//    }
    
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
        cSet.insert(c)
        if (from > c.time!) { from = c.time! }
        if (to < c.time!) { to = c.time! }
    }
    cx.from = from
    cx.to = to
    cx.addToCandles(NSSet(set: cSet, copyItems: false))
    try moc.save()
}

typealias HandlerLoadCandles = (CandlesBA)->Void
func getHandler()->HandlerLoadCandles{return handler}
let handler:HandlerLoadCandles = { (candles) in
    DispatchQueue.main.async {
        print(candles.candles.count)
        guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return XCTFail()}
        var lastTime = ""
        do {
            let moc = try db().open(forEnv: "DEMO", modelURL: url)
            try storeCandles(moc: moc, candles: candles.candles, accountType: "demo", granularity: candles.granularity, instrument: candles.instrument)
        } catch {
            XCTFail()
        }
        if candles.candles.count==5000 {
            candlesLoaderTest(from: lastTime, handler: getHandler())
        }
    }
}

func candlesLoaderTest(from: String, handler: @escaping HandlerLoadCandles) {
//    Network().candles(from: from, completionHandler: handler1)
}

class DbTests: XCTestCase {
    let from = "2020-01-01T00:00:00.000Z"
    
//    func testDemo() {
//        candlesLoaderTest(from: from, handler: handler)
//        dispatchMain()
//    }
    
    func xtestCandleBA() {
        guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return XCTFail()}
        let d = db()
        do{
            let decoder = JSONDecoder()
            let cO = try decoder.decode(CandlesBA.self, from:candles.data(using: .utf8)!)
            let i = cO.instrument
            let g = cO.granularity
            let moc = try d.open(forEnv: "CI", modelURL: url)
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CandleBA")
            fetch.predicate = NSPredicate(format: "granularity == %@ AND instrument == %@", g, i)
            let cBA1 = try moc.fetch(fetch) as! [CandleBA_dto]
            XCTAssert(cBA1.count == 1)
        } catch let error {
                print(error)
                XCTFail()
        }
    }
    
    func xtestCandle() {
        guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return XCTFail()}
        let d = db()
        do{
            let decoder = JSONDecoder()
            let cO = try decoder.decode(CandlesBA.self, from:candles.data(using: .utf8)!)
            let i = cO.instrument
            let g = cO.granularity
            let moc = try d.open(forEnv: "CI", modelURL: url)
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Candle")
            fetch.predicate = NSPredicate(format: "candleBA.granularity == %@ AND candleBA.instrument == %@", g, i)
            let cBA1 = try moc.fetch(fetch) as! [Candle_dto]
            XCTAssert(cBA1.count == 6)
        } catch let error {
                print(error)
                XCTFail()
        }
    }

    func testDb() {
        guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return XCTFail()}
        let d = db()
        do{
            let moc = try d.open(forEnv: "CI", modelURL: url)

//            candlesLoader(from: from, handler: handler)
            let decoder = JSONDecoder()
            let cO = try decoder.decode(CandlesBA.self, from:candles.data(using: .utf8)!)
            let i = cO.instrument
            let g = cO.granularity
            let cx = NSEntityDescription.insertNewObject(forEntityName: "CandleBA", into: moc) as! CandleBA_dto
            cx.instrument = i
            cx.granularity = g
            var cSet = Set<Candle_dto>()
            var from = Date() + (100 * 356 * 24 * 60 * 60)
            var to = Date() - (100 * 356 * 24 * 60 * 60)
            for c1 in cO.candles {
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
                c.c_hash = Int64((i + g).hash) + Int64(c1.time_date.toString.hash)
                cSet.insert(c)
                if (from > c.time!) { from = c.time! }
                if (to < c.time!) { to = c.time! }
            }
            cx.from = from
            cx.to = to
            cx.addToCandles(NSSet(set: cSet, copyItems: false))
            try moc.save()
        } catch let error {
                print(error)
                XCTFail()
        }
        xtestCandleBA()
        xtestCandle()
    }

}
