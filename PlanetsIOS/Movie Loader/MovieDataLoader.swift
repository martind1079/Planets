//
//  MovieDataLoader.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation
import CorePlanets

public protocol MoviewDataLoaderTask {
    func cancel()
}

public protocol MovieDataLoader {
    typealias Result = Swift.Result<[Movie], Error>
    func loadMovie(from path: String, completion: @escaping (Result) -> Void) -> MoviewDataLoaderTask
}
