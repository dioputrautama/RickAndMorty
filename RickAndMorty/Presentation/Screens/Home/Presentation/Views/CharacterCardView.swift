//
//  CharacterCardView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 20/08/24.
//

import SwiftUI

struct CharacterCardView: View {
    @State var character: CharacterEntity?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(Assets.Image.dummy)
                .cornerRadius(8)

            Text(character?.name ?? "")
                .font(Typography.size14Bold)
                .foregroundStyle(Colors.white)

            VStack(alignment: .leading, spacing: 6) {
                makeIconAndLabel(icon: Assets.Icons.alien, title: "Human")

                makeIconAndLabel(icon: Assets.Icons.planet, title: "Earth (C-137)")
            }
        }
        .padding(.all, 8)
        .background(Colors.shark)
        .cornerRadius(8)
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
}
