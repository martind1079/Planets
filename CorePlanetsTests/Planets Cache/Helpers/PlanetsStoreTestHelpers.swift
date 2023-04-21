//
//  PlanetsStoreTestHelpers.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import Foundation
import CorePlanets

var uniqueItem: Planet {
    Planet(name: "any name", rotationPeriod: "", orbitalPeriod: "", diameter: "", climate: "", gravity: "", terrain: "", surfaceWater: "", population: "", residents: [], films: [], created: "", edited: "", url: "https://anyUrl")
}

func uniquePlanetFeed() -> (models: [Planet], local: [LocalPlanet]) {
    let models = [uniqueItem, uniqueItem]
    let local = models.map { LocalPlanet(name: $0.name, rotationPeriod: $0.rotationPeriod, orbitalPeriod: $0.orbitalPeriod, diameter: $0.diameter, climate: $0.climate, gravity: $0.gravity, terrain: $0.terrain, surfaceWater: $0.surfaceWater, population: $0.population, residents: $0.residents, films: $0.films, created: $0.created, edited: $0.edited, url: $0.url) }
    return (models, local)
}

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

class PlanetsStoreSpy: PlanetsStore {

    enum ReceivedMessage: Equatable {
        case deleteCachedPlanets
        case insert([LocalPlanet])
        case retrieve
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    private var retrievalCompletions = [RetrievalCompletion]()
    
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
    
    func insert(_ items: [LocalPlanet], completion: @escaping InsertionCompletion) {
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items))
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        retrievalCompletions.append(completion)
        receivedMessages.append(.retrieve)
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalCompletions[index](.failure(error))
    }
    
    func completeRetrievalWithEmptyCache(at index: Int = 0) {
        retrievalCompletions[index](.empty)
    }
    
    func completeRetrieval(with items: [LocalPlanet], at index: Int = 0) {
        retrievalCompletions[index](.found(items: items))
    }
    
}
