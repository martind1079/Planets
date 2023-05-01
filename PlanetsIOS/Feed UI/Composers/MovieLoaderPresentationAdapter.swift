//
//  MovieLoaderPresentationAdapter.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 01/05/2023.
//

import Foundation
import CorePlanets

final class MovieLoaderPresentationAdapter: PlanetCellControllerDelegate {
    
    private var task: MovieDataLoaderTask?
    private let model: Planet
    private let movieLoader: MovieDataLoader
    var presenter: PlanetPresenter?
    
    init(model: Planet, movieLoader: MovieDataLoader) {
        self.model = model
        self.movieLoader = movieLoader
    }
    
    func didCancelRequest() {
        task?.cancel()
    }
    
    func didRequestMovie() {
        presenter?.didStartLoadingMovies(for: model)
        let paths = model.films.map { $0.url }
        task = movieLoader.loadMovies(from: paths, forURL: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: MovieDataLoader.Result) {
        if let movies = try? result.get() {
            presenter?.didFinishLoadingMovies(with: movies, for: model)
        }
    }
}
