//
//  MovieCache.swift
//  CorePlanets
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation

public protocol MovieCache {
    typealias Result = Swift.Result<Void, Error>
    
    func save(_ movies: [Movie], for url: String, completion: @escaping (Result) -> Void)
}
