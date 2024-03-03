import ComposableArchitecture
import Foundation

protocol NetworkClient {
    func fetch(_ number: Int) async throws -> String
}

class NumberNetworkClient: NetworkClient {
    func fetch(_ number: Int) async throws -> String {
        let (data, _) = try await URLSession.shared.data(from: URL(string: "http://numbersapi.com/\(number)")!)
        return String(decoding: data, as: UTF8.self)
    }
}

extension NumberNetworkClient: DependencyKey {
    static let liveValue = NumberNetworkClient()
}

extension DependencyValues {
    var numberFactProtocol: NumberNetworkClient {
        get { self[NumberNetworkClient.self] }
        set { self[NumberNetworkClient.self] = newValue }
    }
}
