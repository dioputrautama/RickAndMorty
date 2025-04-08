//
//  HomeAllCharacterSection.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 08/04/25.
//

import SwiftUI

struct HomeAllCharacterSection: View {
    private let gridItems = [GridItem(), GridItem(), GridItem()]
    var characters: [CharacterEntity]
    var characterLoadingGetMore: Bool
    var onLoadMore: () -> Void
    var onTapItem: (_ id: Int) -> Void

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: gridItems, spacing: 16) {
                    ForEach(characters) { character in
                        CharacterCardView(character: character)
                            .onTapGesture {
                                onTapItem(character.id)
                            }
                            .onAppear {
                                // Ketika character terakhir muncul, trigger load more
                                if character.id == characters.last?.id {
                                    onLoadMore()
                                }
                            }
                    }

                    if characterLoadingGetMore {
                        ProgressView()
                            .padding()
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.all, 16)
            }
            .coordinateSpace(name: "scroll")
        }
    }
}
