//
//  PlanetViewModel+PrototypeData.swift
//  Planets
//
//  Created by Martin Doyle on 23/04/2023.
//

import Foundation

extension PlanetViewModel {
    static var prototypeFeed: [PlanetViewModel] {
        [
           PlanetViewModel(name: "Tatooine", population: "10000" ,url: ""),
           PlanetViewModel(name: "Yavin IV", population: "500000" , url: ""),
        ]
    }
}
