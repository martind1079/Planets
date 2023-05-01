//
//  PlanetsLoaderPResentationAdapter.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 01/05/2023.
//

import Foundation
import CorePlanets

final class PlanetsLoaderPresentationAdapter: PlanetsRefreshControllerDelegate {
    
    private let loader: PlanetsLoader
    var presenter: FeedPresenter?
    
    init(loader: PlanetsLoader) {
        self.loader = loader
    }
    
    func didRequestPlanetsRefresh() {
        presenter?.didStartLoadingFeed()
        
        loader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoading(with: error)
            }
        }
    }
}


