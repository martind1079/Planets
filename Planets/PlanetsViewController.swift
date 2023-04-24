//
//  PlanetsViewController.swift
//  Planets
//
//  Created by Martin Doyle on 23/04/2023.
//

import UIKit

struct PlanetViewModel {
    var name: String
    var population: String
    var url: String
}

class PlanetsViewController: UITableViewController {
    
    private var feed = [PlanetViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "\(PlanetTableViewCell.self)", bundle: .main), forCellReuseIdentifier: PlanetTableViewCell.reuseIdentifier)
    }
    
    @IBAction func refresh() {
        refreshControl?.beginRefreshing()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.feed = PlanetViewModel.prototypeFeed
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = feed[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanetTableViewCell.reuseIdentifier, for: indexPath) as! PlanetTableViewCell
        cell.configure(with: model)
        return cell
    }
    
}

extension PlanetTableViewCell {
    func configure(with viewModel: PlanetViewModel) {
        nameLabel.text = viewModel.name
        populationLabel.text = "Population: \(viewModel.population)"
    }
}
