//
//  CachePlanetsTests.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 19/04/2023.
//

import XCTest
@testable import CorePlanets

protocol PlanetsCache { }

class LocalPlanetsLoader {
    
    let cache: PlanetsCache
    
    init(cache: PlanetsCache) {
        self.cache = cache
    }
    
    func save(_ items: [Planet]) {
        
    }
    
}

final class CachePlanetsTests: XCTestCase {

    func test_init_doesNotMessageCache() {
        
    }
    
    private func makeSUT() -> (cache: PlanetsCacheSpy, sut: LocalPlanetsLoader) {
        
        let cache = PlanetsCacheSpy()
        let sut = LocalPlanetsLoader(cache: cache)
        return (cache, sut)
    }
    
    private class PlanetsCacheSpy: PlanetsCache {
        
        var insertCallCount = 0
        var deletionCallCount = 0
        
        
        
    }

}
