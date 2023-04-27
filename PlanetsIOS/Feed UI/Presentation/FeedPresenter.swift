//
//  FeedPresenter.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 26/04/2023.
//

import Foundation
import CorePlanets

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewmodel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [Planet]
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    
    private let feedView: FeedView
    private let loadingView: FeedLoadingView
    
    static var title: String {
        return NSLocalizedString("PLANETS_VIEW_TITLE", tableName: "Planet", bundle: Bundle(for: FeedPresenter.self), comment: "Title for the planets feed")
    }
    
    init(feedView: FeedView, loadingView: FeedLoadingView) {
        self.feedView = feedView
        self.loadingView = loadingView
    }
    
    func didStartLoadingFeed() {
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [Planet]) {
        feedView.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
}
