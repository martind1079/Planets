//
//  PlanetsStore.swift
//  CorePlanets
//
//  Created by Martin Doyle on 19/04/2023.
//

import Foundation

public enum RetrieveCachedPlanetsResult {
    case empty
    case found(items: [Planet])
    case failure(Error)
}

public protocol PlanetsStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedPlanetsResult) -> Void
    
    func deleteCachedPlanets(completion: @escaping DeletionCompletion)
    func insert(_ items: [Planet], completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
