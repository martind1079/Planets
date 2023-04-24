//
//  PlanetCellController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import CorePlanets
import UIKit

final class PlanetCellController {
    private var task: MoviewDataLoaderTask?
    var model: Planet
    var movieLoader: MovieDataLoader
    
    init(model: Planet, movieLoader: MovieDataLoader) {
        self.model  = model
        self.movieLoader = movieLoader
    }
    
    func view() -> UITableViewCell {
        let cell = PlanetCell()
        cell.nameLabel.text = model.name
        cell.populationLabel.text = model.population
        cell.moviesLabel.text = ""
        cell.startLoading()
        
        self.task = movieLoader.loadMovie(from: model.url) { [weak cell] result in
            
            if let movies = try? result.get() {
                cell?.moviesLabel.text = movies.movieList()
            }
            cell?.stopLoading()
        }
        
        return cell
    }
    
    func preload() {
        task = movieLoader.loadMovie(from: model.url) { _ in }
    }
    
    deinit {
        task?.cancel()
    }
}

