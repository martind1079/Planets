//
//  FeedViewModel.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import CorePlanets

final class FeedViewModel {

    private let loader: PlanetsLoader
    typealias Observer<T> = (T) -> Void
    
    init(loader: PlanetsLoader) {
        self.loader = loader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onFeedLoad: Observer<[Planet]>?
    
    func loadFeed() {
        onLoadingStateChange?(true)
        loader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
