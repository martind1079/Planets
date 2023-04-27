//
//  MovieDataLoaderCacheDecorator.swift
//  PlanetsApp
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation
import CorePlanets

final class MovieDataLoaderCacheDecorator: MovieDataLoader {
    
    private let decoratee: MovieDataLoader
    private let cache: MovieCache
    
    private class TaskWrapper: MovieDataLoaderTask {
        
        var wrapped: MovieDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
        
    init(decoratee: MovieDataLoader, cache: MovieCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadMovies(from paths: [String], forURL url: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = decoratee.loadMovies(from: paths, forURL: url) { [weak self] result in
            switch result {
            case .success(let movies):
                
                self?.cache.save(movies, for: url) { _ in }
                
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
}
