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
        let presentationAdapter = PlanetsLoaderPresentationAdapter(loader: MainQueueDispatchDecorator(loader))
        let refreshController = FeedRefreshController(delegate: presentationAdapter)
        
        
        let planetsController = PlanetsViewController.makeWith(refreshController: refreshController, title: FeedPresenter.title)
        
        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: planetsController, movieLoader: MainQueueDispatchDecorator(movieLoader)),
            loadingView: WeakRefVirtualProxy(refreshController))
        
                
        return planetsController
    }
    
}

private extension PlanetsViewController {
    static func makeWith(refreshController: FeedRefreshController, title: String) -> PlanetsViewController {
        let bundle = Bundle(for: PlanetsViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        
        let planetsController = storyboard.instantiateInitialViewController() as! PlanetsViewController
        planetsController.refreshController = refreshController
        planetsController.title = title
        
        return planetsController
    }
}
