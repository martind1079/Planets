//
//  RemoteMovieLoader.swift
//  CorePlanets
//
//  Created by Martin Doyle on 25/04/2023.
//

import Foundation

public final class RemoteMovieLoader: MovieDataLoader {
    private let client: HTTPClient
    
    public init(client: HTTPClient) {
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    private final class HTTPClientTaskWrapper: MovieDataLoaderTask {
        private var completion: ((MovieDataLoader.Result) -> Void)?
        
        var wrapped: HTTPClientTask?
        
        init(_ completion: @escaping (MovieDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: MovieDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    @discardableResult
    public func loadMovies(from path: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        task.wrapped = client.get(from: URL(string: path)!) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success((data, response)):
                if response.statusCode == 200, !data.isEmpty {
                    let decoder = JSONDecoder()
                    if let movies = try? decoder.decode([Movie].self, from: data) {
                        task.complete(with: .success(movies))
                    } else {
                        task.complete(with: .failure(Error.invalidData))
                    }
                } else {
                    task.complete(with: .failure(Error.invalidData))
                }
            case let .failure(error): task.complete(with: .failure(error))
            }
        }
        return task
    }
}
