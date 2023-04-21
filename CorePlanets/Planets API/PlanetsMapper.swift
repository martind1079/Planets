import Foundation

internal final class PlanetsMapper {
	private struct Root: Decodable {
		let results: [Planet]
	}
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
	
	private static var OK_200: Int { return 200 }
	
	internal static func map(_ data: Data, from response: HTTPURLResponse) -> RemotePlanetsLoader.Result {
		guard response.statusCode == OK_200,
			let root = try? decoder.decode(Root.self, from: data) else {
			return .failure(RemotePlanetsLoader.Error.invalidData)
		}

		return .success(root.results)
	}
}
