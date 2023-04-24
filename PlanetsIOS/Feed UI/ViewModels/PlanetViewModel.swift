//
//  PlanetViewModel.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import Foundation
import CorePlanets

final class PlanetViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private var task: MovieDataLoaderTask?
    private let model: Planet
    private let movieLoader: MovieDataLoader
    
    init(model: Planet, movieLoader: MovieDataLoader) {
        self.model = model
        self.movieLoader = movieLoader
    }
    
    var name: String? {
        return model.name
    }
    
    var population: String?  {
        return model.population
    }
 
    
    var onMovieLoad: Observer<[Movie]>?
    var onMovieLoadingStateChange: Observer<Bool>?
    
    func loadMovies() {
        onMovieLoadingStateChange?(true)
        task = movieLoader.loadMovie(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: MovieDataLoader.Result) {
        if let movies = try? result.get() {
            onMovieLoad?(movies)
        }
        onMovieLoadingStateChange?(false)
    }
    
    func cancelMovieLoad() {
        task?.cancel()
        task = nil
    }
}
