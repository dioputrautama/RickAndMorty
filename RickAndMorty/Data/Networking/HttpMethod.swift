//
//  HttpMethod.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 24/03/25.
//

enum HTTPMethod {
    case get
    case post
    case put
    case delete

    public var rawValue: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        case .put: "PUT"
        case .delete: "DELETE"
        }
    }
}
