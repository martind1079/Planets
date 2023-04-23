//
//  PlanetsAPIEndToEndTests.swift
//  PlanetsAPIEndToEndTests
//
//  Created by Martin Doyle on 18/04/2023.
//

import XCTest
import CorePlanets

final class PlanetsAPIEndToEndTests: XCTestCase {

    func test_httpGETResponse_matchesExpectedResult() {
        let testServerURL = URL(string: "https://swapi.dev/api/planets/")!
        let client = URLSessionHTTPClient()
        let loader = RemotePlanetsLoader(url: testServerURL, client: client)
        
        trackForMemoryLeaks(client)
        trackForMemoryLeaks(loader)
        
        let exp = expectation(description: "wait for response")
        var receivedResult: PlanetsLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 20.0)
        
        switch receivedResult {
        case let .success(planets)?:
            XCTAssertEqual(planets.count, 10, "Expected 10 items in the planets response")
        case let .failure(error)?:
            XCTFail("Expeceted success, got \(error) instead")
        default:
            XCTFail("Expected success, got no response")
        }
    }
}
