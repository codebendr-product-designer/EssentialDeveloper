import Foundation

// Inverse Dependency

public class ApiClient {
    public static let instance = ApiClient()

    private init() {}

    public func execute(_: URLRequest, completion _: (Data) -> ()) {}
}

public struct LoggedInUser {}
