//
//  CodablePlanetsStore.swift
//  CorePlanets
//
//  Created by Martin Doyle on 20/04/2023.
//

import Foundation

public class CodablePlanetsStore: PlanetsStore {
    
    private enum Error: Swift.Error {
        case failedToLoadData
        case failedToFindStore
    }
    
    private struct CodablePlanet: Codable {
        let name: String
        let rotationPeriod: String
        let orbitalPeriod: String
        let diameter: String
        let climate: String
        let gravity: String
        let terrain: String
        let surfaceWater: String
        let population: String
        let residents: [String]
        let films: [String]
        let created: String
        let edited: String
        let url: String
        
        init(_ planet: LocalPlanet) {
            name = planet.name
            rotationPeriod = planet.rotationPeriod
            orbitalPeriod = planet.orbitalPeriod
            diameter = planet.diameter
            climate = planet.climate
            gravity = planet.gravity
            terrain = planet.terrain
            surfaceWater = planet.surfaceWater
            population = planet.population
            residents = planet.residents
            films = planet.films
            created = planet.created
            edited = planet.edited
            url = planet.url
        }
        
        var local: LocalPlanet {
            return LocalPlanet(name: name, rotationPeriod: rotationPeriod, orbitalPeriod: orbitalPeriod, diameter: diameter, climate: climate, gravity: gravity, terrain: terrain, surfaceWater: surfaceWater, population: population, residents: residents, films: films, created: created, edited: edited, url: url)
        }
    }
    
    private let queue = DispatchQueue(label: "\(CodablePlanetsStore.self)Queue", qos: .userInitiated, attributes: .concurrent)
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        self.storeURL = storeURL
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        let storeURL = self.storeURL
        queue.async {
            guard let data = try? Data(contentsOf: storeURL) else {
                completion(.success(.none))
                return
            }
            do {
                let decoder = JSONDecoder()
                let items = try decoder.decode([CodablePlanet].self, from: data)
                completion(.success(items.map { $0.local }))
            } catch {
                completion(.failure(error))
            }
        }
    }
     
    public func insert(_ items: [LocalPlanet], completion: @escaping InsertionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            completion( Result {
                let encoder = JSONEncoder()
                let encoded = try encoder.encode(items.map(CodablePlanet.init))
                try encoded.write(to: storeURL)
            })
        }
    }
    
    public func deleteCachedPlanets(completion: @escaping DeletionCompletion) {
        let storeURL = self.storeURL
        queue.async(flags: .barrier) {
            guard FileManager.default.fileExists(atPath: storeURL.path) else {
                return completion(.failure(Error.failedToFindStore))
            }
            completion( Result {
                try FileManager.default.removeItem(at: storeURL)
            })
        }
    }
}

