//
//  CoreDataPlanetsStore.swift
//  CorePlanets
//
//  Created by Martin Doyle on 22/04/2023.
//

import Foundation
import CoreData

public class CoreDataPlanetsStore: PlanetsStore {
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "PlanetsCache", url: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            completion( Result {
                try ManagedCache.find(in: context)?.localFeed
            })
        }
    }
    
    public func deleteCachedPlanets(completion: @escaping DeletionCompletion) {
        perform { context in
            completion(Result {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
            })
        }
    }
    
    public func insert(_ items: [CorePlanets.LocalPlanet], completion: @escaping InsertionCompletion) {
        perform { context in
            completion(Result {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.items = ManagedPlanet.items(from: items, in: context)
                
                try context.save()
            })
        }
    }
    
    private func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
    
}
