import Foundation

public struct Planet: Decodable, Equatable {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.rotationPeriod = try container.decode(String.self, forKey: .rotationPeriod)
        self.orbitalPeriod = try container.decode(String.self, forKey: .orbitalPeriod)
        self.diameter = try container.decode(String.self, forKey: .diameter)
        self.climate = try container.decode(String.self, forKey: .climate)
        self.gravity = try container.decode(String.self, forKey: .gravity)
        self.terrain = try container.decode(String.self, forKey: .terrain)
        self.surfaceWater = try container.decode(String.self, forKey: .surfaceWater)
        self.population = try container.decode(String.self, forKey: .population)
        self.residents = try container.decode([String].self, forKey: .residents)
        let filmURLS = try container.decode([String].self, forKey: .films)
        self.created = try container.decode(String.self, forKey: .created)
        self.edited = try container.decode(String.self, forKey: .edited)
        self.url = try container.decode(String.self, forKey: .url)
        
        self.films = filmURLS.map { Movie(title: "", url: $0, openingCrawl: "")}
    }
    
    
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
