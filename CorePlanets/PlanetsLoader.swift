import Foundation

public protocol PlanetsLoader {
    
    typealias Result = Swift.Result<[Planet], Error>
    
	func load(completion: @escaping (Result) -> Void)
}
