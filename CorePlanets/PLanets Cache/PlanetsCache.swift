//
//  PlanetsCache.swift
//  CorePlanets
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation

public protocol PlanetCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ items: [Planet], completion: @escaping (Result) -> Void)
}
