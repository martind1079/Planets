//
//  PlanetCellController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import CorePlanets
import UIKit

protocol PlanetCellControllerDelegate {
    func didRequestMovie()
    func didCancelRequest()
}

final class PlanetCellController: PlanetView {

    private let delegate: PlanetCellControllerDelegate
    private var cell: PlanetCell?
    
    init(delegate: PlanetCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestMovie()
        cell?.startLoading()
        return cell!
    }
    
    func display(_ viewModel: PlanetViewModel) {
       // DispatchQueue.main.async {
            self.cell?.nameLabel.text = viewModel.name
            self.cell?.populationLabel.text = "Population: \(viewModel.population)"
            self.cell?.moviesLabel.text = viewModel.movies.movieList()
            self.cell?.stopLoading()
      //  }
    }
    
    
    func preload() {
        delegate.didRequestMovie()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelRequest()
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

