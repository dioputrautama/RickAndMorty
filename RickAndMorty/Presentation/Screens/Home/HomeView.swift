//
//  HomeView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 15/08/24.
//

import SwiftUI

struct HomeView: View {
    private let gridItems = [GridItem(.adaptive(minimum: 110))]
    @StateObject private var tabBarVisibility = TabBarVisibility.shared
    @StateObject private var vm: HomeViewModel = HomeViewModel()

    init(vm: HomeViewModel = HomeViewModel()) {
        _vm = StateObject(wrappedValue: vm)
    }

    var body: some View {
        ZStack {
            Colors.background
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(vm.characters) { character in
                        CharacterCardView(character: character)
                    }
                }
                .padding(.all, 16)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewOffsetKey.self,
                                           value: -$0.frame(in: .named("scroll")).origin.y)
                })
                .onPreferenceChange(ViewOffsetKey.self) { offset in
                    withAnimation(.easeInOut(duration: 0.3)) {
                        tabBarVisibility.isHideTabBar = offset > 150
                    }
                }
            }
            .coordinateSpace(name: "scroll")
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
