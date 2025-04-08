//
//  AppRoute.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 08/04/25.
//

import SwiftUI

protocol AppRouterProtocol: ObservableObject {
    func navigate(to route: RoutePath)
    func pop()
    func popToRoot()
}

final class AppRouter: AppRouterProtocol {
    @Published var path = NavigationPath()

    func navigate(to route: RoutePath) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
