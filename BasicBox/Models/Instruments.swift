struct Instruments: Decodable {
    let instruments: Array<Instrument>
    struct Instrument: Decodable {
        let name: String
    }
}

extension Instruments {
    var allSorted: [String] {
        self.instruments.map { instrument -> String in
            instrument.name
        }.sorted()
    }
    var all_csv: String {
        var array = [String]()
        self.instruments.forEach { (instrument) in
            array.append(instrument.name)
        }
        return array.joined(separator: ",")
    }
}
