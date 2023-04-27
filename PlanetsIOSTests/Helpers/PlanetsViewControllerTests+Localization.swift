//
//  PlanetsViewControllerTests+Localization.swift
//  PlanetsIOSTests
//
//  Created by Martin Doyle on 27/04/2023.
//

import Foundation
import XCTest
import PlanetsIOS

extension PlanetsUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Planet"
        let bundle = Bundle(for: PlanetsViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
