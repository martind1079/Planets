//
//  XCTestCase+FailableInsertPlanetsStoreSpecs.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import XCTest
import CorePlanets

extension FailableInsertPlanetsStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        let insertionError = insert(items: uniquePlanetFeed().local, to: sut)
        
        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error", file: file, line: line)
    }
    
    func assertThatInsertHasNoSideEffectsOnInsertionError(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        
        insert(items: uniquePlanetFeed().local, to: sut)
        expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
}
