//
//  LocalPlanet.swift
//  CorePlanets
//
//  Created by Martin Doyle on 20/04/2023.
//

import Foundation

public struct LocalPlanet: Equatable {
    public let name: String
    public let rotationPeriod: String
    public let orbitalPeriod: String
    public let diameter: String
    public let climate: String
    public let gravity: String
    public let terrain: String
    public let surfaceWater: String
    public let population: String
    public let residents: [String]
    public let films: [Movie]
    public let created: String
    public let edited: String
    public let url: String
    
    
    public init(name: String, rotationPeriod: String, orbitalPeriod: String, diameter: String, climate: String, gravity: String, terrain: String, surfaceWater: String, population: String, residents: [String], films: [Movie], created: String, edited: String, url: String) {
        self.name = name
        self.rotationPeriod = rotationPeriod
        self.orbitalPeriod = orbitalPeriod
        self.diameter = diameter
        self.climate = climate
        self.gravity = gravity
        self.terrain = terrain
        self.surfaceWater = surfaceWater
        self.population = population
        self.residents = residents
        self.films = films
        self.created = created
        self.edited = edited
        self.url = url
    }
}


