//
//  ManagedPlanet.swift
//  CorePlanets
//
//  Created by Martin Doyle on 21/04/2023.
//

import CoreData

@objc(ManagedPlanet)
public class ManagedPlanet: NSManagedObject {
    @NSManaged internal var name: String
    @NSManaged internal var rotationPeriod: String
    @NSManaged internal var orbitalPeriod: String
    @NSManaged internal var diameter: String
    @NSManaged internal var climate: String
    @NSManaged internal var gravity: String
    @NSManaged internal var terrain: String
    @NSManaged internal var surfaceWater: String
    @NSManaged internal var population: String
    @NSManaged internal var created: String
    @NSManaged internal var edited: String
    @NSManaged internal var url: String
    @NSManaged internal var films: NSOrderedSet
    @NSManaged internal var residents: NSOrderedSet
    @NSManaged internal var cache: ManagedCache
}

extension ManagedPlanet {
    
    static func first(with url: String, in context: NSManagedObjectContext) throws -> ManagedPlanet? {
        let request = NSFetchRequest<ManagedPlanet>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedPlanet.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
    
    
    internal static func items(from localFeed: [LocalPlanet], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: localFeed.map { local in
            let managed = ManagedPlanet(context: context)
            managed.name = local.name
            managed.rotationPeriod = local.rotationPeriod
            managed.orbitalPeriod = local.orbitalPeriod
            managed.diameter = local.diameter
            managed.climate = local.climate
            managed.gravity = local.gravity
            managed.terrain = local.terrain
            managed.surfaceWater = local.surfaceWater
            managed.population = local.population
            managed.created = local.created
            managed.edited = local.edited
            managed.url = local.url
            
            managed.films = NSOrderedSet(array: local.films.map { ManagedFilm.with(context: context, movie: $0)})
            return managed
        })
    }
    
    var local: LocalPlanet {
        let movies: [Movie] = films.compactMap { Movie.from(managed: $0 as! ManagedFilm) }
        
        return LocalPlanet(name: name, rotationPeriod: rotationPeriod, orbitalPeriod: orbitalPeriod, diameter: diameter, climate: climate, gravity: gravity, terrain: terrain, surfaceWater: surfaceWater, population: population, residents: [], films: movies, created: created, edited: edited, url: url)
    }
}

extension ManagedFilm {
    static func with(context: NSManagedObjectContext, movie: Movie) -> ManagedFilm {
        let managed = ManagedFilm(context: context)
        managed.title = movie.title
        managed.path = movie.url
        managed.descriptor = movie.openingCrawl
        return managed
    }
}
