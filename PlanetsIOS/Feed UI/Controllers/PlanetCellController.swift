//
//  PlanetCellController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import CorePlanets
import UIKit

final class PlanetCellController {

    private let viewModel: PlanetViewModel
    
    init(viewModel: PlanetViewModel) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(PlanetCell())
        viewModel.loadMovies()
        return cell
    }
    
    private func binded(_ cell: PlanetCell) -> PlanetCell {

        cell.nameLabel.text = viewModel.name
        cell.populationLabel.text = viewModel.population
        
        viewModel.onMovieLoad = { [weak cell] movies in
            cell?.moviesLabel.text = movies.movieList()
        }
        
        viewModel.onMovieLoadingStateChange = { [weak cell] isLoading in
            cell?.isLoading = isLoading
        }
        
        return cell
    }
    
    func preload() {
        viewModel.loadMovies()
    }
    
    func cancelLoad() {
        viewModel.cancelMovieLoad()
    }
}

