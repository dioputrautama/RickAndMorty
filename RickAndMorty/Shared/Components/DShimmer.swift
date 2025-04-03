//
//  DShimmer.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 03/04/25.
//

import SwiftUI

public struct DShimmerViewModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.6), Color.clear]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .rotationEffect(.degrees(30))
                .offset(x: phase * 350)
                .blendMode(.plusLighter)
            )
            .mask(content)
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1
                }
            }
    }
}

extension View {
    func dshimmer() -> some View {
        self.modifier(DShimmerViewModifier())
    }
}


public struct DShimmerView: View {
    var width: CGFloat = 100
    var height: CGFloat = 16
    var cornerRadius: CGFloat = 8
    var baseColor: Color = .gray.opacity(0.3)
    var shimmerColor: Color = .gray.opacity(0.6)

    @State private var phase: CGFloat = -1

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(baseColor)
            .frame(width: width, height: height)
            .overlay(
                shimmerOverlay
                    .mask(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .frame(width: width, height: height)
                    )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 2
                }
            }
    }

    var shimmerOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [.clear, shimmerColor, .clear]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .rotationEffect(.degrees(30))
        .offset(x: phase * 200)
    }
}

extension DShimmerView {
    @discardableResult
    public func size(width: CGFloat, height: CGFloat) -> DShimmerView {
        var copy = self
        copy.width = width
        copy.height = height
        return copy
    }

    @discardableResult
    public func cornerRadius(_ radius: CGFloat) -> DShimmerView {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }

    @discardableResult
    public func baseColor(_ color: Color) -> DShimmerView {
        var copy = self
        copy.baseColor = color
        return copy
    }

    @discardableResult
    public func shimmerColor(_ color: Color) -> DShimmerView {
        var copy = self
        copy.shimmerColor = color
        return copy
    }
}
