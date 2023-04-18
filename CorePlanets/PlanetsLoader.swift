import Foundation

public enum LoadPlanetsResult {
	case success([Planet])
	case failure(Error)
}

public protocol PlanetsLoader {
	func load(completion: @escaping (LoadPlanetsResult) -> Void)
}
