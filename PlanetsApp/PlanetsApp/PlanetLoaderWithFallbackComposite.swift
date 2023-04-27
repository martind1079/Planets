//
//  PlanetLoaderWithFallbackComposite.swift
//  PlanetsApp
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation
import CorePlanets

class PlanetLoaderWithFallbackComposite: PlanetsLoader {
    
    private var primaryLoader: PlanetsLoader
    private var fallbackLoader: PlanetsLoader
    
    init(primaryLoader: PlanetsLoader, fallbackLoader: PlanetsLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    func load(completion: @escaping (PlanetsLoader.Result) -> Void) {
        primaryLoader.load { [weak self] result in
            switch result {
            case .success(let planets):
                guard !planets.isEmpty else {
                    self?.fallbackLoader.load(completion: completion)
                    return
                }
                completion(.success(planets))
            case .failure:
                self?.fallbackLoader.load(completion: completion)
            }
        }
    }
    
}
