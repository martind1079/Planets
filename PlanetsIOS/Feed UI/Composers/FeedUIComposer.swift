//
//  FeedUIComposer.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import CorePlanets
import UIKit

public final class FeedUIComoposer {
    private init() { }
    
    public static func feedComposedWith(loader: PlanetsLoader, movieLoader: MovieDataLoader) -> PlanetsViewController {
        let viewModel = FeedViewModel(loader: loader)
        let refreshController = FeedRefreshController(viewModel: viewModel)
        
        let bundle = Bundle(for: PlanetsViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        
        let planetsController = storyboard.instantiateInitialViewController() as! PlanetsViewController
        planetsController.refreshController = refreshController
        
        
        viewModel.onFeedLoad = adaptFeedToCellControllers(formwardingTo: planetsController, movieLoader: movieLoader)
        
        return planetsController
    }
    
    private static func adaptFeedToCellControllers(formwardingTo viewController: PlanetsViewController, movieLoader: MovieDataLoader) -> ([Planet]) -> Void {
        return { [weak viewController] feed in
            viewController?.tableModel = feed.map {
                PlanetCellController(viewModel: PlanetViewModel(model: $0, movieLoader: movieLoader))
            }
        }
    }
}
