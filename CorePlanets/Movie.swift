//
//  Movie.swift
//  CorePlanets
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation

public struct Movie: Decodable {
    public var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public extension Array where Element == Movie {
    func movieList() -> String {
        var results = [String]()
        self.forEach {
            results.append($0.name)
        }
        return results.joined(separator: ", ")
    }
}
