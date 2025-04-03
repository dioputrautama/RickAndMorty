//
//  Constants+ApiConfig.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 24/03/25.
//

import Foundation

extension Constants {
    enum ApiConfig {
        static var baseUrl: String {
            return Bundle.main.infoDictionary?["BASE_URL"] as? String ?? ""
        }
    }
}
