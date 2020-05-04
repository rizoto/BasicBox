//
//  TickCacheXPC.swift
//  BasicBox
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import Foundation
import Combine

@objc(TickCacheXPCProtocol) protocol TickCacheXPCProtocol {
    func areWeReady(reply: ((Bool, Double) -> Void)!)
    func getTicks(reply: ((Data?) -> Void)!)
}

class TickCache: NSObject, Publisher {
    typealias Output = FlatPrice
    typealias Failure = Error

    private var sub: AnySubscriber<Output, Failure>?
    private var subscription: TickCacheSubscription?
    
    private var cancelled = false

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        self.sub = AnySubscriber(subscriber)
        subscription = TickCacheSubscription(combineIdentifier: CombineIdentifier(), cache: self)
        subscriber.receive(subscription: subscription!)
        start()
    }
    
    private func start() {
        let connection = NSXPCConnection(machServiceName: "au.com.itroja.TickTackXPC")
        connection.remoteObjectInterface = NSXPCInterface(with: TickCacheXPCProtocol.self)
        connection.resume()

        let service = connection.remoteObjectProxyWithErrorHandler { error in
            self.sub?.receive(completion: .failure(error))
        } as? TickCacheXPCProtocol

        service!.getTicks { (aData) in
                    aData!.withUnsafeBytes({ ptr in
                        let i = ptr.bindMemory(to: FlatPrice.self)
                        var bytes = i.enumerated().makeIterator()
                        while let byte = bytes.next() {
                            if self.cancelled { break }
                            let price = byte.element
                            _ = self.sub?.receive(price)
                        }
                    })
            _ = self.sub?.receive(completion: .finished)
        }
    }
    
    private struct TickCacheSubscription: Subscription {
        let combineIdentifier: CombineIdentifier
        weak var cache: TickCache?

        func request(_ demand: Subscribers.Demand) {
        }

        func cancel() {
            cache?.cancelled = true
        }
    }
}
