//
//  MovieDataLoaderWithFallbackComposite.swift
//  PlanetsApp
//
//  Created by Martin Doylečon 25/04/2023.
//

import Foundation
import CorePlanets

class MovieDataLoaderWithFallbackComposite: MovieDataLoader {
    
    private var primaryLoader: MovieDataLoader
    private var fallbackLoader: MovieDataLoader
    
    private class TaskWrapper: MovieDataLoaderTask {
        var wrapped: MovieDataLoaderTask?
        
        func cancel() {
            wrapped?.cancel()
        }
    }
    
    init(primaryLoader: MovieDataLoader, fallbackLoader: MovieDataLoader) {
        self.primaryLoader = primaryLoader
        self.fallbackLoader = fallbackLoader
    }
    
    
    func loadMovies(from paths: [String], forURL url: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        let task = TaskWrapper()
        task.wrapped = primaryLoader.loadMovies(from: paths, forURL: url) { [weak self] result in
            switch result {
            case .success(let movies):
                guard let movie = movies.first, !movie.title.isEmpty else {
                    task.wrapped = self?.fallbackLoader.loadMovies(from: paths, forURL: url, completion: completion)
                    return
                }
                completion(.success(movies))
            case .failure:
                task.wrapped = self?.fallbackLoader.loadMovies(from: paths, forURL: url, completion: completion)
            }
        }
        return task
    }
}
