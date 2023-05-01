//
//  FeedViewAdapter.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 01/05/2023.
//

import Foundation
import CorePlanets

final class FeedViewAdapter: FeedView {
    
    weak var controller: PlanetsViewController?
    var movieLoader: MovieDataLoader
    
    init(controller: PlanetsViewController? = nil, movieLoader: MovieDataLoader) {
        self.controller = controller
        self.movieLoader = movieLoader
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = MovieLoaderPresentationAdapter(model: model, movieLoader: movieLoader)
            let view = PlanetCellController(delegate: adapter)
            
            adapter.presenter = PlanetPresenter(view: WeakRefVirtualProxy(view))
            
            return view
        }
    }

}
