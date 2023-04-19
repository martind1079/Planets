//
//  LocalPlanetsLoader.swift
//  CorePlanets
//
//  Created by Martin Doyle on 19/04/2023.
//

import Foundation

public final class LocalPlanetsLoader {
    private let store: PlanetsStore
    
    public typealias SaveResult = Error?
    public typealias LoadResult = LoadPlanetsResult
    
    public init(store: PlanetsStore) {
        self.store = store
    }
    
    public func save(_ items: [Planet], completion: @escaping (SaveResult) -> Void) {
        store.deleteCachedPlanets { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [unowned self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .found(planets):
                completion(.success(planets))
                
            case .empty:
                completion(.success([]))
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
