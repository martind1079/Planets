//
//  Movie.swift
//  CorePlanets
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation

public struct Movie: Decodable {
    public var title: String
    
    public init(title: String) {
        self.title = title
    }
}

public extension Array where Element == Movie {
    func movieList() -> String {
        var results = [String]()
        self.forEach {
            results.append($0.title)
        }
        return results.joined(separator: ", ")
    }
}
