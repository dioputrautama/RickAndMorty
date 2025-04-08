//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 15/08/24.
//

import SwiftUI

@main
struct RickAndMortyApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                HomeView()
                    .navigationDestination(for: RoutePath.self) { route in
                        switch route {
                        case .home:
                            HomeView()
                        case .puzzle:
                            PuzzleView()
                        }
                    }
            }
            .environmentObject(router) // ✅ penting
        }
    }
}

