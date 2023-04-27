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
      //  DispatchQueue.main.async {
            if viewModel.isLoading {
                self.view.beginRefreshing()
            } else {
                self.view.endRefreshing()
            }
       // }
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
        view.backgroundColor = .white
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}


