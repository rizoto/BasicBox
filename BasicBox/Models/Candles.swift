import Foundation
struct Candle: Encodable, Decodable {
    let complete: Bool
    let volume: Int
    let time: String
    let bid : BidAsk
    let ask: BidAsk
    struct BidAsk: Encodable, Decodable {
        let o: String
        let h: String
        let l: String
        let c: String
    }
}

struct CandleD {
    let complete: Bool
    let volume: Int
    let time: Date
    let bid : BidAsk
    let ask: BidAsk
    struct BidAsk {
        let o: Double
        let h: Double
        let l: Double
        let c: Double
    }
}
    
struct CandlesBA: Encodable, Decodable {
    let instrument: String
    let granularity: String
    let candles: Array<Candle>
}

extension Candle {
    var time_date: Date {
        return self.time.toDate
    }
    var json: String {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(self)
            return String(data: jsonData, encoding: .utf8)!
        } catch {
            return ""
        }
    }
}

extension Candle.BidAsk {
    var m: Double {
        return (o.d + h.d + l.d + c.d)/4
    }
}

extension String {
    var d: Double {
        return Double(self) ?? 0
    }
}
