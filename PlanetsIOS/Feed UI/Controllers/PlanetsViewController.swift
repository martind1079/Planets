//
//  PlanetsViewController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit

public class PlanetsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    var refreshController: FeedRefreshController?
    var tableModel = [PlanetCellController]() {
        didSet {
            self.tableView.reloadData()
        }
    }
        
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = refreshController?.view
        refreshController?.refresh()
        tableView.separatorColor = .white
        
        view.backgroundColor = UIColor(patternImage: UIImage.Planet.backgroundImage)
        
    }
    
    convenience init(refreshController: FeedRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cellController(forRowAt: $0).preload()
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(caencelCellControllerLoad)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        caencelCellControllerLoad(forRowAt: indexPath)
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> PlanetCellController {
        return tableModel[indexPath.row]
    }
    
    private func caencelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
