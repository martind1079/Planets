//
//  PlanetStoreSpecs.swift
//  CorePlanetsTests
//
//  Created by Martin Doyle on 20/04/2023.
//

import Foundation

protocol PlanetsStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache()
    func test_retrieve_hasNoSideEffectsOnEmptyCache()
    func test_retrieve_deliversFoundValuesOnNonEmptyCache()

    func test_insert_overridesPreviouslyInsertedCacheValues()
    
    func test_delete_hasNoSideEffectsOnEmptyCache()
    func test_delete_emptiesPreviouslyInsertedCache()
    
    func test_storeSideEffects_runSerially()
}

protocol FailableRetrievePlanetsStoreSpecs: PlanetsStoreSpecs {
    func test_retrieve_hasNoSideEffectOnNonEmptyCache()
    func test_retrieve_deliversFailureOnRetrievalError()
}

protocol FailableInsertPlanetsStoreSpecs: PlanetsStoreSpecs {
    func test_insert_deliversErrorOnInsertionError()
    func test_insert_hasNoSideEffectsOnInsertionError()
}

protocol FailableDeletePlanetsStoreSpecs: PlanetsStoreSpecs {
    func test_delete_deliversErrorOnDeletionError()
    func test_delete_hasNoSideEffectsOnDeletionError()
}

typealias FailablePlanetStoreSpecs = FailableDeletePlanetsStoreSpecs & FailableInsertPlanetsStoreSpecs & FailableRetrievePlanetsStoreSpecs
