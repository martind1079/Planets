//
//  PlanetLoaderCacheDecorator.swift
//  PlanetsApp
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation
import CorePlanets

final class PlanetLoaderCacheDecorator: PlanetsLoader {
    private let decoratee: PlanetsLoader
    private let cache: PlanetCache
    
    init(decoratee: PlanetsLoader, cache: PlanetCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func load(completion: @escaping (PlanetsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            if let feed = try? result.get() {
                self?.cache.saveIgnoringResult(feed)
            }
            completion(result)
        }
    }
}

private extension PlanetCache {
    func saveIgnoringResult(_ items: [Planet]) {
        save(items) { _ in }
    }
}
