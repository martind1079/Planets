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
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .failure(error):
                self.store.deleteCachedPlanets { _ in }
                completion(.failure(error))

            case let .found(planets):
                completion(.success(planets.toModels()))
                
            case .empty:
                completion(.success([]))
            }
        }
    }
    
    private func cache(_ items: [Planet], with completion: @escaping (SaveResult) -> Void) {
        store.insert(items.toLocal()) { [weak self] error in
            guard self != nil else { return }
            
            completion(error)
        }
    }
}

private extension Array where Element == Planet {
    func toLocal() -> [LocalPlanet] {
        return map { LocalPlanet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url) }
    }
}

private extension Array where Element == LocalPlanet {
    func toModels() -> [Planet] {
        return map { Planet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url) }
    }
}
