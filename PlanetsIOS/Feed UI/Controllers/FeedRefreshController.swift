//
//  FeedRefreshController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit
import CorePlanets

final class FeedRefreshController: NSObject {
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    var onRefresh: (([Planet]) -> Void)?
    
    private let loader: PlanetsLoader
    
    init(loader: PlanetsLoader) {
        self.loader = loader
    }
    
    @objc func refresh() {
        view.beginRefreshing()
        loader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            
            self?.view.endRefreshing()
        }
    }
    
}


