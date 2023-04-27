//
//  SceneDelegate.swift
//  PlanetsApp
//
//  Created by Martin Doyle on 25/04/2023.
//

import UIKit

import CoreData
import CorePlanets
import PlanetsIOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://swapi.dev/api/planets/")!
        let session = URLSession(configuration: .ephemeral)
        
        let remoteClient = URLSessionHTTPClient(session: session)
        let remotePlanetsLoader = RemotePlanetsLoader(url: url, client: remoteClient)
        let remoteMovieLoader = RemoteMovieLoader(client: remoteClient)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appending(component: "planet-store.sqlite")
        
        let localStore = try! CoreDataPlanetsStore(storeURL: localStoreURL, bundle: Bundle(for: ManagedCache.self))
        let localPlanetsLoader = LocalPlanetsLoader(store: localStore)
        let localMovieLoader = LocalMovieDataLoader(store: localStore)
        
        let compositePlanetsLoader = PlanetLoaderWithFallbackComposite(
            primaryLoader:
                PlanetLoaderCacheDecorator(
                    decoratee: remotePlanetsLoader,
                    cache: localPlanetsLoader),
            fallbackLoader: localPlanetsLoader)
        
        let compositeMovieDataLoader = MovieDataLoaderWithFallbackComposite(
            primaryLoader: localMovieLoader,
            fallbackLoader: MovieDataLoaderCacheDecorator (
                decoratee: remoteMovieLoader,
                cache: localMovieLoader))
        
        let planetsViewController = FeedUIComoposer.feedComposedWith(loader: compositePlanetsLoader, movieLoader: compositeMovieDataLoader)
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [planetsViewController]
        setNavigationBarAppeareance()
        
        window?.rootViewController = navigationController
        
    }
    
    func setNavigationBarAppeareance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
    }
}

