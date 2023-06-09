//
//  Copyright © 2019 Essential Developer. All rights reserved.
//

import Foundation

extension CoreDataPlanetsStore: MovieDataStore {
    
    enum Error: Swift.Error {
        case notFound
    }
    
    public func insert(_ movies: [Movie], for url: String, completion: @escaping (MovieDataStore.InsertionResult) -> Void) {
        perform { context in
            completion(Result {
                try ManagedPlanet.first(with: url, in: context)
                    .map { managedPlanet in
                        managedPlanet.films = NSOrderedSet(array: movies.map {
                            ManagedFilm.with(context: context, movie: $0)
                        })
                    }
                    .map(context.save)
            })
        }
    }
    
	public func retrieve(dataForURL url: String, completion: @escaping (MovieDataStore.RetrievalResult) -> Void) {
		perform { context in
            
            guard let planet = try? ManagedPlanet.first(with: url, in: context) else {
                completion(.failure(Error.notFound))
                return
            }
            completion(.success(
                planet.films.map {
                    Movie.from(managed:  ($0 as! ManagedFilm))
                }
            ))
		}
	}
}

extension Movie {
    static func from(managed: ManagedFilm) -> Movie {
        Movie(title: managed.title!, url: managed.path!, openingCrawl: managed.descriptor!)
    }
}
