//
//  PlanetsViewController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit
import CorePlanets

public class PlanetsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var refreshController: FeedRefreshController?
    private var tableModel = [Planet]() {
        didSet { tableView.reloadData() }
    }
    private var movieLoader: MovieDataLoader?
    
    var cellControllers = [IndexPath: PlanetCellController]()
    
    public convenience init(loader: PlanetsLoader, movieLoader: MovieDataLoader) {
        self.init()
        self.refreshController = FeedRefreshController(loader: loader)
        self.movieLoader = movieLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] feed in
            self?.tableModel = feed
        }
        tableView.prefetchDataSource = self
        refreshController?.refresh()
    }
    
    
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cellController(forRowAt: $0).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PlanetCellController {
        let cellModel = tableModel[indexPath.row]
        let cellController = PlanetCellController(model: cellModel, movieLoader: movieLoader!)
        cellControllers[indexPath] = cellController
        return cellController
    }
    
    private func removeCellController(forRowAt indexPath: IndexPath) {
        cellControllers[indexPath] = nil
    }
}
