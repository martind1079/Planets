//
//  XCTestCase+FeedStoreSpecs.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import XCTest
import CorePlanets

extension PlanetsStoreSpecs where Self: XCTestCase {
    
    func assertThatRetrieveDeliversEmptyOnEmptyCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: .empty, file: file, line: line)
        expect(sut, toRetrieve: .empty, file: file, line: line)
    }
    
    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        let items = uniquePlanetFeed().local
        
        insert(items: items, to: sut)
        
        expect(sut, toRetrieve: .found(items: items), file: file, line: line)
    }
    
    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        let items = uniquePlanetFeed().local
        
        insert(items: items, to: sut)
        
        expect(sut, toRetrieve: .found(items: items), file: file, line: line)
        expect(sut, toRetrieve: .found(items: items), file: file, line: line)
    }
    
    func asserThatInsertOverridesPreviouslyInsertedCacheValues(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        let firstInsertionError = insert(items: uniquePlanetFeed().local, to: sut)
        XCTAssertNil(firstInsertionError, "Expected to insert cache successfully")
        
        let latestFeed = uniquePlanetFeed().local
        let latestInsertionError = insert(items: latestFeed, to: sut)
        
        XCTAssertNil(latestInsertionError, "Expected to override cache successfully")
        expect(sut, toRetrieve: .found(items: latestFeed))
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        
        insert(items: uniquePlanetFeed().local, to: sut)
        let deletionError = deleteCache(from: sut)
        
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed")
        expect(sut, toRetrieve: .empty)
    }
    
    func assertThatStoreSideEffectsRunSerially(on sut: PlanetsStore, file: StaticString = #file, line: UInt = #line) {
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert(uniquePlanetFeed().local) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedPlanets { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert(uniquePlanetFeed().local) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")
    }
    
}

extension PlanetsStoreSpecs where Self: XCTestCase {
    
    @discardableResult
    func insert(items: [LocalPlanet], to sut: PlanetsStore) -> Error? {
        let exp = expectation(description: "")
        var insertionError: Error?
        sut.insert(items) { receivedInsertionError  in
            XCTAssertNil(insertionError)
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func deleteCache(from sut: PlanetsStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedPlanets { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
        return deletionError
    }
    
    func expect(_ sut: PlanetsStore, toRetrieve expectedResult: RetrieveCachedPlanetsResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "")
        
        sut.retrieve { retrievedResult in
            switch (retrievedResult, expectedResult) {
            case (.empty, .empty),
                (.failure, .failure):
                break
            case let (.found(expected), .found(retrieved)):
                XCTAssertEqual(expected, retrieved, file: file, line: line)
            default:
                XCTFail("expected to receive \(expectedResult), got \(retrievedResult) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}


