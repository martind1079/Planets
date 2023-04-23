//
//  StorePlanetsTests.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 19/04/2023.
//

import XCTest
@testable import CorePlanets

final class StorePlanetsTests: XCTestCase {

    func test_init_doesNotMessageCache() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()

        sut.save(items) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPlanets])
    }
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPlanets])
    }
    
    func test_save_requestsNewCacheInsertionOnSuccessfulDeletion() {
        let feed = uniquePlanetFeed()
        let (sut, store) = makeSUT()
        
        sut.save(feed.models) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPlanets, .insert(feed.local)])
    }
    
    func test_save_failsOnDeletionError() {
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
    }
    
    func test_save_failsOnInsertionError() {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }
    
    func test_save_succeedsOnSuccessfulCacheInsertion() {
        let (sut, store) = makeSUT()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_doesNotDeliverDeletionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PlanetsStoreSpy()
        var sut: LocalPlanetsLoader? = LocalPlanetsLoader(store: store)
        
        var receivedResults = [LocalPlanetsLoader.SaveResult]()
        sut?.save([uniqueItem]) { receivedResults.append($0) }
        
        sut = nil
        store.completeDeletion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    func test_save_doesNotDeliverInsertionErrorAfterSUTInstanceHasBeenDeallocated() {
        let store = PlanetsStoreSpy()
        var sut: LocalPlanetsLoader? = LocalPlanetsLoader(store: store)
        
        var receivedResults = [LocalPlanetsLoader.SaveResult]()
        sut?.save([uniqueItem]) { receivedResults.append($0) }
        
        store.completeDeletionSuccessfully()
        sut = nil
        store.completeInsertion(with: anyNSError())
        
        XCTAssertTrue(receivedResults.isEmpty)
    }
    
    private func makeSUT() -> (sut: LocalPlanetsLoader, store: PlanetsStoreSpy) {
        
        let cache = PlanetsStoreSpy()
        let sut = LocalPlanetsLoader(store: cache)
        return (sut, cache)
    }
    
    private func expect(_ sut: LocalPlanetsLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueItem]) { result in
            if case let Result.failure(error) = result { receivedError = error }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
