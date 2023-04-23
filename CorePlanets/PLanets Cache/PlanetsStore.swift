//
//  PlanetsStore.swift
//  CorePlanets
//
//  Created by Martin Doyle on 19/04/2023.
//

import Foundation

public typealias CachedPlanets = [LocalPlanet]

public protocol PlanetsStore {
    typealias DeletionResult = Result<Void, Error>
    typealias DeletionCompletion = (DeletionResult) -> Void
    typealias insertionResult = Result<Void, Error>
    typealias InsertionCompletion = (insertionResult) -> Void
    
    typealias RetrievalResult = Result<CachedPlanets?, Error>
    typealias RetrievalCompletion = (RetrievalResult) -> Void
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func deleteCachedPlanets(completion: @escaping DeletionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func insert(_ items: [LocalPlanet], completion: @escaping InsertionCompletion)
    
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
