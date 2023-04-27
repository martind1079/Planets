//
//  Movie.swift
//  CorePlanets
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation

public struct Movie: Codable, Equatable {
    public var title: String
    public var url: String
    public var openingCrawl: String
    
    
    public init(title: String, url: String, openingCrawl: String) {
        self.title = title
        self.url = url
        self.openingCrawl = openingCrawl
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
