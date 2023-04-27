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

private final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
}

extension MainQueueDispatchDecorator: PlanetsLoader where T == PlanetsLoader {
    func load(completion: @escaping (PlanetsLoader.Result) -> Void) {
        decoratee.load { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
    }
}

extension MainQueueDispatchDecorator: MovieDataLoader where T == MovieDataLoader {
    
    func loadMovies(from paths: [String], forURL url: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        decoratee.loadMovies(from: paths, forURL: url) { result in
            if Thread.isMainThread {
                completion(result)
            } else {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }
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

public final class WeakRefVirtualProxy<T: AnyObject> {
    weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: PlanetView where T: PlanetView {
    func display(_ viewModel: PlanetViewModel) {
        object?.display(viewModel)
    }
}

private final class FeedViewAdapter: FeedView {
    
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

private final class MovieLoaderPresentationAdapter: PlanetCellControllerDelegate {
    
    private var task: MovieDataLoaderTask?
    private let model: Planet
    private let movieLoader: MovieDataLoader
    var presenter: PlanetPresenter?
    
    init(model: Planet, movieLoader: MovieDataLoader) {
        self.model = model
        self.movieLoader = movieLoader
    }
    
    func didCancelRequest() {
        task?.cancel()
    }
    
    func didRequestMovie() {
        presenter?.didStartLoadingMovies(for: model)
        let paths = model.films.map { $0.url }
        task = movieLoader.loadMovies(from: paths, forURL: model.url) { [weak self] result in
            self?.handle(result)
        }
    }
    
    private func handle(_ result: MovieDataLoader.Result) {
        if let movies = try? result.get() {
            presenter?.didFinishLoadingMovies(with: movies, for: model)
        }
    }
}

private final class PlanetsLoaderPresentationAdapter: PlanetsRefreshControllerDelegate {
    
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
