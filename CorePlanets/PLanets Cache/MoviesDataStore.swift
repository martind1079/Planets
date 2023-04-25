//
//  MoviesDataStore.swift
//  CorePlanets
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation

public protocol MovieDataStore {
    typealias RetrievalResult = Swift.Result<[Movie], Error>
    typealias InsertionResult = Swift.Result<Void, Error>

    func insert(_ movies: [Movie], for url: String, completion: @escaping (InsertionResult) -> Void)
    func retrieve(dataForURL url: String, completion: @escaping (RetrievalResult) -> Void)
}
