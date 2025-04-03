//
//  NetworkManager.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 21/08/24.
//

import Foundation

protocol NetworkingProtocol {
    @discardableResult func baseUrl(_ url: String) -> Self
    @discardableResult func pathUrl(_ url: String) -> Self
    @discardableResult func method(_ method: HTTPMethod) -> Self
    @discardableResult func header(_ headers: [String: Any]) -> Self
    @discardableResult func body(_ body: [String: Any]) -> Self
    @discardableResult func timeout(_ seconds: Double) -> Self
    func cancelAllTasks()
    func send<T: Decodable>(responseType: T.Type) async throws -> T
}

final class Networking: NetworkingProtocol {
    private var service: URLSession = .shared
    private var urlRequest: URLRequest?

    private var baseUrlString: String = ""
    private var headers: [String: Any]?
    private var body: [String: Any]?
    private var timeout: Double = 30

    private var pathString: String = ""
    private var httpMethod: HTTPMethod = .get
    private var responseType: (any Decodable.Type)?

    init() {}

    /// REMOVE ALL TASKS
    func cancelAllTasks() {
        service.getAllTasks { tasks in
            tasks.forEach { $0.cancel() }
        }
    }

}

extension Networking {

    /// SET BASE URL
    @discardableResult
    func baseUrl(_ url: String) -> Self {
        self.baseUrlString = url
        return self
    }

    /// SET PATH URL
    @discardableResult
    func pathUrl(_ url: String) -> Self {
        self.pathString = url
        return self
    }

    /// SET METHOD
    @discardableResult
    func method(_ method: HTTPMethod) -> Self {
        self.httpMethod = method
        return self
    }

    /// SET HEADER
    @discardableResult
    func header(_ headers: [String: Any]) -> Self {
        self.headers = headers
        return self
    }

    /// SET BODY (Optional JSON)
    @discardableResult
    func body(_ body: [String: Any]) -> Self {
        self.body = body
        return self
    }

    /// SET TIMEOUT
    @discardableResult
    func timeout(_ seconds: Double) -> Self {
        self.timeout = seconds
        return self
    }

    // ✅ ASYNC Mode with completion
    func send<T: Decodable>(responseType: T.Type) async throws -> T {
        createUrlRequest()

        guard let urlRequest = urlRequest else {
            throw NSError(domain: "Invalid Request", code: -999)
        }

        let (data, _) = try await service.data(for: urlRequest)
        let decoded = try JSONDecoder().decode(T.self, from: data)

        return decoded
    }

    func createUrlRequest() {
        let fullUrl = baseUrlString + pathString

        print("~ Fullurl: \(fullUrl)")
        guard let url = URL(string: fullUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        if let headers = headers {
            headers.forEach { key, value in
                request.setValue("\(value)", forHTTPHeaderField: key)
            }

        }

        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }

        request.timeoutInterval = timeout

        urlRequest = request
    }
}
