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
        
        var wrapped = [HTTPClientTask]()
        
        init(_ completion: @escaping (MovieDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: MovieDataLoader.Result) {
            switch result {
            case .failure: cancel()
            default: break
            }
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped.forEach {
                $0.cancel()
            }
        }
        
        private func preventFurtherCompletions() {
            completion = nil
        }
    }
    
    private func loadIndividualMovie(paths: [String], task: HTTPClientTaskWrapper, completion: @escaping (MovieDataLoader.Result) -> Void) {
        var capturedMovies = [Movie]()
        var count = 0
        for path in paths {
            
            task.wrapped.append( client.get(from: URL(string: path)!) { [weak self] result in
                guard self != nil else { return }
                count += 1
                
                switch result {
                case let .success((data, response)):
                    if response.statusCode == 200, !data.isEmpty {
                        let decoder = JSONDecoder()
                        if let movie = try? decoder.decode(Movie.self, from: data) {
                           // task.complete(with: .success(movies))
                            capturedMovies.append(movie)
                            if count == paths.count {
                                task.complete(with: .success(capturedMovies))
                            }
                        } else {
                             task.complete(with: .failure(Error.invalidData))
                        }
                    } else {
                         task.complete(with: .failure(Error.invalidData))
                    }
                case let .failure(error):
                    task.complete(with: .failure(error))
                }
            })
            
        }
        
    }
    
    
    @discardableResult
    public func loadMovies(from paths: [String], completion: @escaping (MovieDataLoader.Result) -> Void) -> MovieDataLoaderTask {
        let task = HTTPClientTaskWrapper(completion)
        loadIndividualMovie(paths: paths, task: task, completion: completion)
        return task
    }
}
