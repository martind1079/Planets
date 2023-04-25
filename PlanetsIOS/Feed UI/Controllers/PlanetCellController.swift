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
    var cancelLoading = false
    
    init(viewModel: PlanetViewModel) {
        self.viewModel = viewModel
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell") as! PlanetCell
        let planetCell = binded(cell)
        viewModel.loadMovies()
        return planetCell
    }
    
    private func binded(_ cell: PlanetCell) -> PlanetCell {
        cell.nameLabel.text = viewModel.name
        cell.populationLabel.text = viewModel.population
        
        viewModel.onMovieLoad = { [weak cell, weak self] movies in
            guard let self = self, !self.cancelLoading else { return }
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
        cancelLoading = true
        viewModel.cancelMovieLoad()
    }
}

