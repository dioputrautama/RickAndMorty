//
//  HomeView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 15/08/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var tabBarVisibility = TabBarVisibility.shared
    @StateObject private var vm: HomeViewModel = HomeViewModel()
    @EnvironmentObject var route: AppRouter

    init(vm: HomeViewModel = HomeViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            Colors.background
                .ignoresSafeArea()

            switch vm.allCharacterState {
            case .idle, .loading:
                CharacterLoadingView()
            case .success(let data, let loadMore):
                HomeAllCharacterSection(characters: data, characterLoadingGetMore: loadMore) {
                    vm.getAllCharacter()
                } onTapItem: { id in
                    route.navigate(to: .puzzle)
                }
            case .error(let message):
                Text("Error: \(message)")
            }
        }
        .onAppear() {
            vm.getAllCharacter()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
        HomeView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
