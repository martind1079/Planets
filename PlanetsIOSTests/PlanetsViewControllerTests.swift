//
//  PlanetsViewControllerTests.swift
//  PlanetsIOSTests
//
//  Created by Martin Doyle on 24/04/2023.
//

import XCTest
import UIKit
import CorePlanets
import PlanetsIOS

final class PlanetsViewControllerTests: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading completes With Error")
    }
    
    func test_loadFeedCompletion_rendersSuccessfullyLoadedFeed() {
        
        let planet0 = makePlanet(name: "a name", population: "10000")
        let planet1 = makePlanet(name: "a name 2", population: "50000")
        let planet2 = makePlanet(name: "a name 3", population: "100000000")
        let planet3 = makePlanet(name: "a name 4", population: "100")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeFeedLoading(with: [planet0], at: 0)
        assertThat(sut, isRendering: [planet0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading(with: [planet0, planet1, planet2, planet3], at: 1)
        assertThat(sut, isRendering: [planet0, planet1, planet2, planet3])
    }
    
    func test_loadFeedCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let planet0 = makePlanet(name: "a name", population: "100000")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeFeedLoading(with: [planet0], at: 0)
        assertThat(sut, isRendering: [planet0])
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoadingWithError(at: 1)
        assertThat(sut, isRendering: [planet0])
    }
    
    func test_planetView_loadsMoviesWhenVisible() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        
        XCTAssertEqual(loader.loadedMoviePaths, [], "expected no movies requested until planets became visible")
        
        sut.simulatePlanetViewVisible(at: 0)
        XCTAssertEqual(loader.loadedMoviePaths, [planet0.url])
        
        sut.simulatePlanetViewVisible(at: 1)
        XCTAssertEqual(loader.loadedMoviePaths, [planet0.url, planet1.url])
        
    }
    
    func test_planetView_cancelsLoadingMoviesWhenNotVisibleAnyMore() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        
        XCTAssertEqual(loader.cancelledImagePaths, [], "expected no cancellations until planets are no longer visible")
        sut.simulatePlanetViewNotVisible(at: 0)
        
        XCTAssertEqual(loader.cancelledImagePaths, [planet0.url], "expected cancellation when planet0 is no longer visible")
        
        sut.simulatePlanetViewNotVisible(at: 1)
        
        XCTAssertEqual(loader.cancelledImagePaths, [planet0.url, planet1.url], "expected cancellations when planet1 is no longer visible")
        
    }
    
    func test_movieLoadingIndicator_isVisibleWhenLoadingMovies() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        
        let view0 = sut.simulatePlanetViewVisible(at: 0)
        let view1 = sut.simulatePlanetViewVisible(at: 1)
        
        XCTAssertEqual(view0?.isShowingLoadingIndicator, true, "expected cell to show loading indicator when visible and loading movies")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, true, "expected cell to show loading indicator when visible and loading movies")
        
        loader.completeMovieLoading(at: 0)
        
        XCTAssertEqual(view0?.isShowingLoadingIndicator, false, "expected cell to not show loading indicator when visible and loading completes")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, true, "expected cell to show loading indicator when visible and loading movies")
        
        
        loader.completeMovieLoading(at: 1)
        
        XCTAssertEqual(view0?.isShowingLoadingIndicator, false, "expected cell to not show loading indicator when visible and loading completes")
        XCTAssertEqual(view1?.isShowingLoadingIndicator, false, "expected cell to not show loading indicator when visible and loading completes")
        
    }
    
    func test_moviesLabel_displaysMoviesLoadedFromURL() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        
        let view0 = sut.simulatePlanetViewVisible(at: 0)
        let view1 = sut.simulatePlanetViewVisible(at: 1)
        
        XCTAssertEqual(view0?.displayedMovies, .none, "expected no displayed movies before loading completions")
        XCTAssertEqual(view1?.displayedMovies, .none, "expected no displayed movies before loading completions")
        
        let movies = [Movie(name: "Star Wars"), Movie(name: "Star Trek")]
        loader.completeMovieLoading(with: movies, at: 0)
        
        XCTAssertEqual(view0?.displayedMovies, movies.movieList(), "expected displayed movies after successfull loading completion")
        XCTAssertEqual(view1?.displayedMovies, .none, "expected no displayed movies before loading completions")
        
        let movies1 = [Movie(name: "Avengers"), Movie(name: "SpiderMan")]
        loader.completeMovieLoading(with: movies1, at: 1)
        
        XCTAssertEqual(view0?.displayedMovies, movies.movieList(), "expected displayed movies after successfull loading completion")
        XCTAssertEqual(view1?.displayedMovies, movies1.movieList(), "expected displayed movies after successfull loading completion")
        
    }
    
    func test_moviesView_loadsMoviewsWhenNearVisible() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        XCTAssertEqual(loader.loadedMoviePaths, [])
        
        sut.simulatePlanetViewNearlyVisble(at: 0)
        XCTAssertEqual(loader.loadedMoviePaths, [planet0.url], "Expected load request when cell nearly visible")
        
        sut.simulatePlanetViewNearlyVisble(at: 1)
        XCTAssertEqual(loader.loadedMoviePaths, [planet0.url, planet1.url], "Expected load request when cell nearly visible")
        
    }
    
    func test_moviesView_cancelsMovieLoadWhenNotNearVisible() {
        let planet0 = makePlanet(name: "any name", population: "10000", url: "https://url")
        let planet1 = makePlanet(name: "any name 1", population: "10080", url: "https://url-1")
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        loader.completeFeedLoading(with: [planet0, planet1])
        
        XCTAssertEqual(loader.cancelledImagePaths, [], "expected no cancellations until planets are no longer visible")
        sut.simulatePlanetViewNotNearVisble(at: 0)
        
        XCTAssertEqual(loader.cancelledImagePaths, [planet0.url], "expected cancellation when planet0 is no longer visible")
        
        sut.simulatePlanetViewNotNearVisble(at: 1)
        
        XCTAssertEqual(loader.cancelledImagePaths, [planet0.url, planet1.url], "expected cancellations when planet1 is no longer visible")
    }

    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: PlanetsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = PlanetsViewController(loader: loader, movieLoader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(_ sut: PlanetsViewController, isRendering feed: [Planet], file: StaticString = #file, line: UInt = #line) {
        guard sut.numberOfRenderedPlanets() == feed.count else {
            return XCTFail("Expected \(feed.count) images, got \(sut.numberOfRenderedPlanets()) instead.", file: file, line: line)
        }
        
        feed.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    private func assertThat(_ sut: PlanetsViewController, hasViewConfiguredFor planet: Planet, at index: Int, file: StaticString = #file, line: UInt = #line) {
        let view = sut.planet(at: index)
        
        guard let cell = view as? PlanetCell else {
            return XCTFail("Expected \(PlanetCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }

        
        XCTAssertEqual(cell.nameText, planet.name, "Expected name text to be \(String(describing: planet.name)) for planet  view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.populationText, planet.population, "Expected description text to be \(String(describing: planet.population)) for image view at index (\(index)", file: file, line: line)
    }
    
    private func makePlanet(name: String, population: String, url: String = "http://anuURL") -> Planet {
        Planet(name: name, rotationPeriod: "", orbitalPeriod: "", diameter: "", climate: "", gravity: "", terrain: "", surfaceWater: "", population: population, residents: [], films: [], created: "", edited: "", url: url)
    }

    class LoaderSpy: PlanetsLoader, MovieDataLoader {
        private var planetRequests = [(PlanetsLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            return planetRequests.count
        }
        
        func load(completion: @escaping (PlanetsLoader.Result) -> Void) {
            planetRequests.append(completion)
        }
        
        func completeFeedLoading(with feed: [Planet] = [], at index: Int = 0) {
            planetRequests[index](.success(feed))
        }
    
        func completeFeedLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "an error", code: 0)
            planetRequests[index](.failure(error))
        }
        
        // MARK:  MovieDataLoader methods
        
        private struct TaskSpy: MoviewDataLoaderTask {
            let cancelCalback: () -> Void
            func cancel() {
                cancelCalback()
            }
        }
        
        var loadedMoviePaths: [String] {
            movieRequests.map {
                $0.path
            }
        }
        var cancelledImagePaths = [String]()
        
        private var movieRequests = [(path: String, completion: (MovieDataLoader.Result) -> Void)]()
        
        func completeMovieLoading(with movies: [Movie] = [Movie(name: "A name")], at index: Int = 0) {
            movieRequests[index].completion(.success(movies))
        }
        
        func completeMovieLoadingWithError(at index: Int = 0) {
            let error = NSError(domain: "Test", code: 0)
            movieRequests[index].completion(.failure(error))
        }
        
        func cancelMovieLoad(from path: String) {
            cancelledImagePaths.append(path)
        }
        
        func loadMovie(from path: String, completion: @escaping (MovieDataLoader.Result) -> Void) -> MoviewDataLoaderTask {
            movieRequests.append((path, completion))
            return TaskSpy { [weak self] in self?.cancelledImagePaths.append(path) }
        }
        
    }
}

private extension PlanetsViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
            
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    @discardableResult
    func simulatePlanetViewVisible(at index: Int = 0) -> PlanetCell? {
        return planet(at: index) as? PlanetCell
    }
    
    func simulatePlanetViewNearlyVisble(at index: Int = 0) {
        let ds = tableView.prefetchDataSource
        let indexPath = IndexPath(row: index, section: planetsSection)
        ds?.tableView(tableView, prefetchRowsAt: [indexPath])
    }
    
    func simulatePlanetViewNotNearVisble(at index: Int = 0) {
        simulatePlanetViewNearlyVisble(at: index)
        let ds = tableView.prefetchDataSource
        let indexPath = IndexPath(row: index, section: planetsSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [indexPath])
    }
    
    func simulatePlanetViewNotVisible(at index: Int = 0) {
        let view = simulatePlanetViewVisible(at: index)
        
        let delegate = tableView.delegate
        let indexPath = IndexPath(row: index, section: planetsSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: indexPath)
    }
    
    func numberOfRenderedPlanets() -> Int {
        return tableView.numberOfRows(inSection: planetsSection)
    }
    
    func planet(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: planetsSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    private var planetsSection: Int {
        return 0
    }
}

private extension PlanetCell {
    
    var nameText: String? {
        return nameLabel.text
    }
    
    var populationText: String? {
        return populationLabel.text
    }
    
    var isShowingLoadingIndicator: Bool {
        return activityIndicator.isAnimating && !activityIndicator.isHidden
    }
    
    var displayedMovies: String? {
        guard let list = moviesLabel.text else { return nil }
        return list.isEmpty ? nil : list
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
