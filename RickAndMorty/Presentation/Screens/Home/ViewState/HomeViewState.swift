//
//  HomeViewState.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 04/04/25.
//

enum HomeViewState<T> {
    case idle
    case loading
    case success(data: T, loadMore: Bool)
    case error(message: String)
}
