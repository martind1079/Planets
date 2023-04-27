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
        let films: [Movie]
        let created: String
        let edited: String
        let url: String
        
        enum CodingKeys: CodingKey {
            case name
            case rotationPeriod
            case orbitalPeriod
            case diameter
            case climate
            case gravity
            case terrain
            case surfaceWater
            case population
            case residents
            case films
            case created
            case edited
            case url
        }
        
        init(from decoder: Decoder) throws {
            let container: KeyedDecodingContainer<CodablePlanetsStore.CodablePlanet.CodingKeys> = try decoder.container(keyedBy: CodablePlanetsStore.CodablePlanet.CodingKeys.self)
            self.name = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.name)
            self.rotationPeriod = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.rotationPeriod)
            self.orbitalPeriod = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.orbitalPeriod)
            self.diameter = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.diameter)
            self.climate = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.climate)
            self.gravity = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.gravity)
            self.terrain = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.terrain)
            self.surfaceWater = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.surfaceWater)
            self.population = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.population)
            self.residents = try container.decode([String].self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.residents)
            let filmURLS = try container.decode([String].self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.films)
            self.created = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.created)
            self.edited = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.edited)
            self.url = try container.decode(String.self, forKey: CodablePlanetsStore.CodablePlanet.CodingKeys.url)
            
            self.films = filmURLS.map { Movie(title: "", url: $0, openingCrawl: "")}
        }
        
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

