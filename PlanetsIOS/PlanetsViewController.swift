//
//  PlanetsViewController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit
import CorePlanets

public extension Array where Element == Movie {
    func movieList() -> String {
        var results = [String]()
        self.forEach {
            results.append($0.name)
        }
        return results.joined(separator: ", ")
    }
}

public protocol MoviewDataLoaderTask {
    func cancel()
}

public protocol MovieDataLoader {
    typealias Result = Swift.Result<[Movie], Error>
    func loadMovie(from path: String, completion: @escaping (Result) -> Void) -> MoviewDataLoaderTask
}

public class PlanetsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    private var loader: PlanetsLoader?
    private var tableModel = [Planet]()
    private var movieLoader: MovieDataLoader?
    
    var tasks = [IndexPath: MoviewDataLoaderTask]()
    
    public convenience init(loader: PlanetsLoader, movieLoader: MovieDataLoader) {
        self.init()
        self.loader = loader
        self.movieLoader = movieLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        tableView.prefetchDataSource = self
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
            if let feed = try? result.get() {
                self?.tableModel = feed
                self?.tableView.reloadData()
            }
            
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = PlanetCell()
        cell.nameLabel.text = cellModel.name
        cell.populationLabel.text = cellModel.population
        cell.moviesLabel.text = ""
        cell.startLoading()
        tasks[indexPath] = movieLoader?.loadMovie(from: cellModel.url) { [weak cell] result in
            
            if let movies = try? result.get() {
                cell?.moviesLabel.text = movies.movieList()
            }
            cell?.stopLoading()
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            let cellModel = tableModel[$0.row]
            tasks[$0] = movieLoader?.loadMovie(from: cellModel.url) { _ in }
        }
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            cancelTask(forRowAt: $0)
        }
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
