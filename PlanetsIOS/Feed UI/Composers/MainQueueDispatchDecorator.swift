//
//  MainQueueDispatchDecorator.swift
//  PlanetsIOS
//
//  Created by Martin Doyle on 29/04/2023.
//

import Foundation
import CorePlanets

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(_ decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            DispatchQueue.main.async { completion() }
            return
        }
        completion()
    }
}

extension MainQueueDispatchDecorator: PlanetsLoader where T == PlanetsLoader {
    func load(completion: @escaping (PlanetsLoader.Result) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}

extension MainQueueDispatchDecorator: MovieDataLoader where T == MovieDataLoader {
    
    func loadMovies(from paths: [String], forURL url: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        decoratee.loadMovies(from: paths, forURL: url) { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
