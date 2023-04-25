//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

public final class LocalMovieDataLoader {
	private let store: MovieDataStore
	
	public init(store: MovieDataStore) {
		self.store = store
	}
}

extension LocalMovieDataLoader {
	public typealias SaveResult = Result<Void, Error>

	public enum SaveError: Error {
		case failed
	}

	public func save(_ movies: [Movie], for url: String, completion: @escaping (SaveResult) -> Void) {
		store.insert(movies, for: url) { [weak self] result in
			guard self != nil else { return }
			
			completion(result.mapError { _ in SaveError.failed })
		}
	}
}

extension LocalMovieDataLoader: MovieDataLoader {
	public typealias LoadResult = MovieDataLoader.Result

	public enum LoadError: Error {
		case failed
		case notFound
	}
	
	private final class LoadMovieDataTask: MovieDataLoaderTask {
		private var completion: ((MovieDataLoader.Result) -> Void)?
		
		init(_ completion: @escaping (MovieDataLoader.Result) -> Void) {
			self.completion = completion
		}
		
		func complete(with result: MovieDataLoader.Result) {
			completion?(result)
		}
		
		func cancel() {
			preventFurtherCompletions()
		}
		
		private func preventFurtherCompletions() {
			completion = nil
		}
	}
	
	public func loadMovies(from path: String, completion: @escaping (LoadResult) -> Void) -> MovieDataLoaderTask {
		let task = LoadMovieDataTask(completion)
		store.retrieve(dataForURL: path) { [weak self] result in
			guard self != nil else { return }
			
            if case let movies = try? result.get() {
                task.complete(with: .success(movies!))
            } else {
                task.complete(with: .failure(LoadError.notFound))
            }
		}
		return task
	}
}
