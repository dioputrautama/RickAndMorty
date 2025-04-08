//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 20/08/24.
//

import SwiftUI

struct CharacterCardView: View {
    @State var character: CharacterEntity?
    @State private var isDownloadImage: Bool = true
    @State private var image: Image? = nil
    private let imageDownloader = ImageDownloader()

    var body: some View {
                VStack(alignment: .leading, spacing: 12) {
                    if isDownloadImage {
                        DShimmerView()
                            .cornerRadius(8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 120)

                    } else {
                        if let image = image {
                            image
                                .resizable()
                                .frame(maxWidth: .infinity)
                                .frame(height: 120)
                                .cornerRadius(8)
                        } else {
                            Image(systemName: "photo.on.rectangle")
                        }
                    }
        
                    Text(character?.name ?? "")
                        .font(Typography.size14Bold)
                        .foregroundStyle(Colors.white)
        
                    VStack(alignment: .leading, spacing: 6) {
                        makeIconAndLabel(icon: Assets.Icons.alien, title: "")
        
                        makeIconAndLabel(icon: Assets.Icons.planet, title: "Earth (C-137)")
                    }
                }
                .padding(.all, 8)
                .background(Colors.shark)
                .cornerRadius(8)
                .task {
                    self.image = await imageDownload(url: character?.image ?? "")
                }
    }

    private func makeIconAndLabel(icon: String, title: String) -> some View {
        return HStack(spacing: 4) {
            Image(icon)
                .resizable()
                .frame(width: 14, height: 14)

            Text(title)
                .font(Typography.size12)
                .foregroundStyle(Colors.white)
        }
    }

    private func imageDownload(url: String) async -> Image? {
        isDownloadImage = true
        defer { isDownloadImage = false }

        guard let url = URL(string: url) else { return nil }
        if let uiImage = await imageDownloader.downloadImageWithCache(url: url) {
            return Image(uiImage: uiImage)
        }
        return nil
    }
}

struct CharacterCardLoadingView: View {
    var body: some View {
        VStack {
            DShimmerView()
                .cornerRadius(8)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
            //                .size(width: .infinity, height: 50)

            DShimmerView()
                .cornerRadius(8)
                .frame(height: 20)
                .frame(maxWidth: .infinity)
                .padding(.trailing, 20)

            DShimmerView()
                .cornerRadius(8)
            //                .size(width: .infinity - 40, height: 25)
                .frame(height: 15)
                .frame(maxWidth: .infinity)
                .padding(.trailing, 40)
        }
        .padding(.all, 8)
        .background(Colors.shark)
        .cornerRadius(8)
    }
}
