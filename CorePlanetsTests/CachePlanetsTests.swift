//
//  CachePlanetsTests.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 19/04/2023.
//

import XCTest
@testable import CorePlanets

protocol PlanetsStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    func deleteCachedPlanets(completion: @escaping DeletionCompletion)
    func insert(_ items: [Planet], completion: @escaping InsertionCompletion)
}

class LocalPlanetsLoader {
    
    let store: PlanetsStore
    public typealias SaveResult = Error?
    
    init(store: PlanetsStore) {
        self.store = store
    }
    
    func save(_ items: [Planet], completion: @escaping (Error?) -> Void) {
        store.deleteCachedPlanets { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    private func cache(_ items: [Planet], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
    
}

final class CachePlanetsTests: XCTestCase {

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
        let items = [uniqueItem, uniqueItem]
        let (sut, store) = makeSUT()
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCachedPlanets, .insert(items)])
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
    
    private var uniqueItem: Planet {
        Planet(name: "any name", rotationPeriod: "", orbitalPeriod: "", diameter: "", climate: "", gravity: "", terrain: "", surfaceWater: "", population: "", residents: [], films: [], created: "", edited: "", url: "https://anyUrl")
    }
    
    private func makeSUT() -> (sut: LocalPlanetsLoader, store: PlanetsStoreSpy) {
        
        let cache = PlanetsStoreSpy()
        let sut = LocalPlanetsLoader(store: cache)
        return (sut, cache)
    }
    
    private func expect(_ sut: LocalPlanetsLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueItem]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    private class PlanetsStoreSpy: PlanetsStore {
        
        enum ReceivedMessage: Equatable {
            case deleteCachedPlanets
            case insert([Planet])
        }
        
        private(set) var receivedMessages = [ReceivedMessage]()
        
        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()
        
        func deleteCachedPlanets(completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCachedPlanets)
        }
        
        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }
        
        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }
        
        func insert(_ items: [CorePlanets.Planet], completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(items))
        }
        
        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }
        
        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }

}
