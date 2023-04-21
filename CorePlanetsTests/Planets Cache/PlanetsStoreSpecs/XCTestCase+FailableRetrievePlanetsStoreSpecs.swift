//
//  XCTestCase+FailableRetrievePlanetsStoreSpecs.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import XCTest
import CorePlanets

extension FailableRetrievePlanetsStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversFailureOnRetrievalError(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnFailure(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
        expect(sut, toRetrieve: .failure(anyNSError()), file: file, line: line)
        
    }
    
}
