//
//  CharacterLoadingView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 08/04/25.
//

import SwiftUI

struct CharacterLoadingView: View {
    var totalItem: Int = 6
    var columns: Int = 3

    private var gridItems: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 12), count: columns)
    }

    var body: some View {
        LazyVGrid(columns: gridItems, spacing: 16) {
            ForEach(0..<totalItem, id: \.self) { _ in
                VStack(alignment: .leading) {
                    DShimmerView()
                        .frame(height: 120)
                        .cornerRadius(8)

                    DShimmerView()
                        .frame(width: 120)
                        .frame(height: 20)
                        .cornerRadius(8)

                }
                .padding(.all, 8)
                .background(Colors.shark)
                .cornerRadius(8)
            }
        }
        .padding(16)
    }
}
