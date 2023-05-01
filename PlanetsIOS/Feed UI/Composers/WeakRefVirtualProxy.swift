//
//  WeakRefVirtualProxy.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 29/04/2023.
//

import Foundation
import CorePlanets

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
