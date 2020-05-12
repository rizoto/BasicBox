//
//  DB.swift
//  OFT
//
//  Created by Lubor Kolacny on 14/9/19.
//  Copyright © 2019 Lubor Kolacny. All rights reserved.
//

import CoreData

struct db {
    let concurencyType: NSManagedObjectContextConcurrencyType
    init(concurencyType: NSManagedObjectContextConcurrencyType = .privateQueueConcurrencyType) {
        self.concurencyType = concurencyType
    }
    func open(forEnv: String, modelURL: URL) throws -> NSManagedObjectContext{
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: self.concurencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let docURL = try getPath(for: "live", broker: "oanda")
        let storeURL = docURL.appendingPathComponent("Oanda\(forEnv).sqlite")
        try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        return managedObjectContext
    }
}

enum DBError: Error {
    case could_not_create_path
}

func getPath(for accountType: String, broker: String) throws -> URL {
    let url = FileManager().homeDirectoryForCurrentUser.appendingPathComponent(".au.com.itroja.trading/\(accountType)/\(broker)/db")
    if checkOrCreatePath(path: url) {
        return url
    } else {
        throw DBError.could_not_create_path
    }
}

func checkOrCreatePath(path: URL) -> Bool {
    do {
        try FileManager().createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    } catch let error {
        print(error)
        return false
    }
    return true
}

func skipDownloaded(from: String, instrument: String, granularity: String) -> String {
    if instrument.isEmpty {
        return from
    }
    guard let url = Bundle.main.url(forResource: "Model", withExtension:"momd") else {return ""}
    do {
        let moc = try db().open(forEnv: "Live_"+granularity, modelURL: url)
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "CandleBA")
        fetch.predicate = NSPredicate(format: "granularity == %@ AND instrument == %@", granularity, instrument)
        let cBA1 = try moc.fetch(fetch) as! [CandleBA_dto]
        if cBA1.count == 1 && cBA1.first!.to! > from.toDate  {
            return convertDate(date: cBA1.first!.to!)
        }
    } catch let error {
        print(error.localizedDescription)
    }
    return from
}

func convertDate(date: Date) -> String {
    let GMT = TimeZone(abbreviation: "GMT")
    let options: ISO8601DateFormatter.Options = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone, .withFractionalSeconds]
    return ISO8601DateFormatter.string(from: date, timeZone: GMT!, formatOptions: options)
}

extension String {
    var toDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone, .withFractionalSeconds]
        return dateFormatter.date(from: self)!
    }
}

extension Date {
    var toString: String {
        let GMT = TimeZone(abbreviation: "GMT")
        let options: ISO8601DateFormatter.Options = [.withInternetDateTime, .withDashSeparatorInDate, .withColonSeparatorInTime, .withTimeZone, .withFractionalSeconds]
        return ISO8601DateFormatter.string(from: self, timeZone: GMT!, formatOptions: options)
    }
}

