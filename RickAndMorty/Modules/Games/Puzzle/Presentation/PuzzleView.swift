//
//  PuzzleView.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 11/10/24.
//

import SwiftUI

struct PuzzleView: View {
    @ObservedObject private var vm: PuzzleVM
    let rects = CGRect(x: 0, y: 0, width: 200, height: 200)

    let columns: [GridItem]

    init(vm: PuzzleVM = PuzzleVM()) {
        self.vm = vm
        self.columns = Array(repeating: GridItem(.flexible()), count: vm.gridSize)
        guard let image = UIImage(named: "dummy") else { return }
        self.vm.createPuzzlePieces(from: image)
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(vm.result) { piece in
                PuzzlePieceView(piece: piece)
            }
        }
        .padding()
//        LineDrawingViewRepresentable()
//                   .frame(width: 300, height: 300)
//                   .border(Color.gray, width: 1)
//                   .onAppear {
//                       // You can dynamically add points here or modify the points array
//                   }
    }
}

struct PuzzlePieceView: View {
    @ObservedObject var piece: PuzzlePiece

    var body: some View {
        piece.image
            .resizable()
            .scaledToFit()
            .offset(x: piece.offset.width + piece.dragOffset.width, y: piece.offset.height + piece.dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        piece.dragOffset = value.translation
                    }
                    .onEnded { _ in
                        piece.offset.width += piece.dragOffset.width
                        piece.offset.height += piece.dragOffset.height
                        piece.dragOffset = .zero
                    }
            )
    }
}

//#Preview {
//    PuzzleView()
//}


import SwiftUI
import UIKit

struct MaskedImageView: View {
    let image: UIImage?

    var body: some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(CustomShape())
        }
    }
}

struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Define the points as before
        let minX = rect.minX
        let minY = rect.minY
        let midX = rect.midX
        let midY = rect.midY
        let maxX = rect.maxX
        let maxY = rect.maxY

        let firstLine = CGPoint(x: midX, y: minY)
        let secondLine = CGPoint(x: midX, y: maxY / 5)
        let thirdLine = CGPoint(x: minX, y: midY)
        let fourthLine = CGPoint(x: maxX, y: midY)

        // Move to starting point and draw lines
        path.move(to: firstLine)
        path.addLine(to: secondLine)

        let curve2 = CGPoint(x: midX + 15, y: (firstLine.y + secondLine.y) + 20)
        let endCurve = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y))
        path.addCurve(to: endCurve, control1: secondLine, control2: curve2)

        let startCurve2 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y))
        let midCurve2 = CGPoint(x: midX + 60, y: (firstLine.y + secondLine.y) + 20)
        let endCurve2 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y) + 40)
        path.addCurve(to: endCurve2, control1: startCurve2, control2: midCurve2)

        let startCurve3 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y) + 40)
        let midCurve3 = CGPoint(x: midX + 15, y: (firstLine.y + secondLine.y) + 20)
        let endCurve3 = CGPoint(x: midX, y: (firstLine.y + secondLine.y) + 40)
        path.addCurve(to: endCurve3, control1: startCurve3, control2: midCurve3)

        // Close the path to form a solid clipping area
        path.addLine(to: CGPoint(x: midX, y: maxY))
        path.addLine(to: CGPoint(x: midX, y: secondLine.y))
        path.addLine(to: thirdLine)
        path.addLine(to: fourthLine)

        path.closeSubpath()  // Important to create a closed path

        return path
    }
}

#Preview {
    MaskedImageView(image: UIImage(named: "dummy")!)
}
