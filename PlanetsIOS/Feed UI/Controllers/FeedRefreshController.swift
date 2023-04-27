//
//  FeedRefreshController.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 24/04/2023.
//

import UIKit

protocol PlanetsRefreshControllerDelegate {
    func didRequestPlanetsRefresh()
}

final class FeedRefreshController: NSObject, FeedLoadingView {
    
    func display(_ viewModel: FeedLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private(set) lazy var view = loadView()
    
    private var delegate: PlanetsRefreshControllerDelegate
    
    init(delegate: PlanetsRefreshControllerDelegate) {
        self.delegate = delegate
    }
    
    @objc func refresh() {
        delegate.didRequestPlanetsRefresh()
    }
    
    private func loadView() -> UIRefreshControl {
        let view = UIRefreshControl()
        view.tintColor = .white
       // view.backgroundColor = .clear
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}


