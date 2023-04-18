//
//  PlanetsAPIEndToEndTests.swift
//  PlanetsAPIEndToEndTests
//
//  Created by Martin Doyle on 18/04/2023.
//

import XCTest
import Planets

final class PlanetsAPIEndToEndTests: XCTestCase {

    func test_httpGETResponse_matchesExpectedResult() {
        let client = URLSessionHTTPClient()
        let loader = RemotePlanetsLoader(client: client)
    }

}
