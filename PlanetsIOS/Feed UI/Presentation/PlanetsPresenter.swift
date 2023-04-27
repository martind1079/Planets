//
//  PlanetsPresenter.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 26/04/2023.
//

import Foundation
import CorePlanets

struct PlanetViewModel {
    var isLoading: Bool
    var name: String
    var population: String
    var movies: [Movie]
}

protocol PlanetView {
    func display(_ viewModel: PlanetViewModel)
}

final class PlanetPresenter {
    
    private let view: PlanetView

    init(view: PlanetView) {
        self.view = view
    }
    
 
    func didStartLoadingMovies(for model: Planet) {
        view.display(PlanetViewModel(
            isLoading: true,
            name: model.name,
            population: model.population,
            movies: []))
    }
    
    func didFinishLoadingMovies(with movies: [Movie], for model: Planet) {
        view.display(PlanetViewModel(
            isLoading: false,
            name: model.name,
            population: model.population,
            movies: movies))
    }
}
