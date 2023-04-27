//
//  MovieDataLoader.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation

public protocol MovieDataLoaderTask {
    func cancel()
}

public protocol MovieDataLoader {
    typealias Result = Swift.Result<[Movie], Error>
    func loadMovies(from paths: [String], forURL: String, completion: @escaping (Result) -> Void) -> MovieDataLoaderTask
}
