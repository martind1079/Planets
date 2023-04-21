//
//  XCTestCase+FailableDeletePlanetsStoreSpecs.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import XCTest
import CorePlanets

extension FailableDeletePlanetsStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNotNil(deletionError, "Expected cache deletion to fail", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnDeletionError(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        deleteCache(from: sut)
        
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
}
