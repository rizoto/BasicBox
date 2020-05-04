//
//  TickCacheTests.swift
//  BasicBoxTests
//
//  Created by Lubor Kolacny on 2/5/20.
//  Copyright © 2020 Lubor Kolacny. All rights reserved.
//

import XCTest
import Combine
@testable import BasicBox

class TickCacheTests: XCTestCase {
    // kinda integration test, we don't knwow of CacheXPC is running
    // should be in integration tests 
    func testCache() throws {
        let expectation = XCTestExpectation(description: self.debugDescription)
        let cache = TickCache()
        let cancellable = cache.sink(receiveCompletion: { e in
            switch e {
            case .finished:
                break
            case .failure(_):
                expectation.isInverted = true
            }
        }) { (price) in
            print(price)
            expectation.fulfill()
        }
        sleep(1)
        cancellable.cancel()
        wait(for: [expectation], timeout: 1.5)
        XCTAssertNotNil(cancellable)
    }

}
