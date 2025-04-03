//
//  PuzzleVM.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 11/10/24.
//


import SwiftUI
import UIKit

class PuzzleVM: ObservableObject {
    @Published var result: [PuzzlePiece] = []

    var gridSize: Int = 1

    init() {}

    func createPuzzlePieces(from image: UIImage) {
//        let puzzleImages = splitImageIntoPieces(image: image, rows: gridSize, columns: gridSize)
        var pieces = [PuzzlePiece]()
        let sizes = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let cropImageIntoPieces = cropImage(image: image, rect: sizes)

        for (index, puzzleImage) in cropImageIntoPieces.enumerated() {
            let piece = PuzzlePiece(
                         image: Image(uiImage: puzzleImage),
                         correctPosition: index,
                         currentPosition: index
                     )
                     pieces.append(piece)
        }

//        for (index, puzzleImage) in puzzleImages.enumerated() {
//            let piece = PuzzlePiece(
//                image: Image(uiImage: puzzleImage),
//                correctPosition: index,
//                currentPosition: index
//            )
//            pieces.append(piece)
//        }

        result = pieces
    }
}

// MARK: PRIVATE FUNCTION
extension PuzzleVM {
    private func splitImageIntoPieces(image: UIImage, rows: Int, columns: Int) -> [UIImage] {
        guard let cgImage = image.cgImage else { return [] }


        let pieceWidth = CGFloat(cgImage.width) / CGFloat(columns)
        let pieceHeight = CGFloat(cgImage.height) / CGFloat(rows)

        var pieces: [UIImage] = []

        for row in 0..<rows {
            for column in 0..<columns {
                let x = CGFloat(column) * pieceWidth
                let y = CGFloat(row) * pieceHeight
                let rect = CGRect(x: x, y: y, width: pieceWidth, height: pieceHeight)

                //                if let croppedCGImage = cgImage.cropping(to: rect) {
                //                    let piece = UIImage(cgImage: croppedCGImage)
                //
                // Apply curved puzzle edges
                if let puzzlePieceWithMask = applyPuzzleMask(to: image, row: row, column: column, rows: rows, columns: columns) {
                    pieces.append(puzzlePieceWithMask)
                }
                //                }
            }
        }

        return pieces
    }

    private func applyPuzzleMask(to image: UIImage, row: Int, column: Int, rows: Int, columns: Int) -> UIImage? {
        let pieceWidth = image.size.width
        let pieceHeight = image.size.height

        UIGraphicsBeginImageContext(image.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        // Define the puzzle piece path using UIBezierPath
        let path = createPuzzlePath(in: CGRect(x: 0, y: 0, width: pieceWidth, height: pieceHeight), row: row, column: column, rows: rows, columns: columns)

        // Add clipping path
        context.addPath(path.cgPath)
        context.clip()

        // Draw the image
        image.draw(at: .zero)

        // Get the masked image
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return maskedImage
    }

    private func createPuzzlePath(in rect: CGRect, row: Int, column: Int, rows: Int, columns: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let bumpSize = min(rect.width, rect.height) / 4

        // Start from top-left corner
        path.move(to: rect.origin)

        addBump(to: path, in: rect, edge: .left, bumpSize: bumpSize, invert: true)

        //        // Top edge
        //        if row == 0 {
        //            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY)) // Flat top for top row
        //        } else {
        //            addBump(to: path, in: rect, edge: .top, bumpSize: bumpSize)
        //        }
        //
        //        // Right edge
        //        if column == columns - 1 {
        //            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY)) // Flat right for rightmost column
        //        } else {
        //            addBump(to: path, in: rect, edge: .right, bumpSize: bumpSize)
        //        }
        //
        //        // Bottom edge
        //        if row == rows - 1 {
        //            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY)) // Flat bottom for bottom row
        //        } else {
        //            addBump(to: path, in: rect, edge: .bottom, bumpSize: bumpSize, invert: true)
        //        }
        //
        //        // Left edge
        //        if column == 0 {
        //            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY)) // Flat left for leftmost column
        //        } else {
        //            addBump(to: path, in: rect, edge: .left, bumpSize: bumpSize, invert: true)
        //        }

        path.close()

        return path
    }

    private enum Edge {
        case top, right, bottom, left
    }

    private func addBump(to path: UIBezierPath, in rect: CGRect, edge: Edge, bumpSize: CGFloat, invert: Bool = false) {
        let minX = rect.minX
        let minY = rect.minY
        let midX = rect.midX
        let midY = rect.midY
        let maxX = rect.maxX
        let maxY = rect.maxY

        let firstLine = CGPoint(x: midX, y: minY)
        let secondLine = CGPoint(x: midX, y: maxY)
        let thirdLine = CGPoint(x: minX, y: midY)
        let fourthLine = CGPoint(x: maxX, y: midY)

        path.move(to: thirdLine)
        path.addLine(to: firstLine)
        path.addLine(to: secondLine)
        path.addLine(to: thirdLine)
        path.addLine(to: fourthLine)
    }

    func cropImage(image: UIImage, rect: CGRect) -> [UIImage] {
            // Create an array to hold cropped images
            var croppedImages: [UIImage] = []

            // Define the lines and regions
            let minX = rect.minX
            let minY = rect.minY
            let midX = rect.midX
            let midY = rect.midY
            let maxX = rect.maxX
            let maxY = rect.maxY

            // Define the crop regions based on the path you've created
            let regions = [
                CGRect(x: minX, y: minY, width: midX - minX, height: midY - minY), // Top-left
                CGRect(x: midX, y: minY, width: maxX - midX, height: midY - minY), // Top-right
                CGRect(x: minX, y: midY, width: midX - minX, height: maxY - midY), // Bottom-left
                CGRect(x: midX, y: midY, width: maxX - midX, height: maxY - midY)  // Bottom-right
            ]

            // Iterate over each region and crop the image
            for region in regions {
                if let croppedCGImage = image.cgImage?.cropping(to: region) {
                    let croppedUIImage = UIImage(cgImage: croppedCGImage)
                    croppedImages.append(croppedUIImage)
                } else {
                   return []
                }
            }

            return croppedImages
        }


    //    private func addBump(to path: UIBezierPath, in rect: CGRect, edge: Edge, bumpSize: CGFloat, invert: Bool = false) {
    //        let midX = rect.midX
    //        let midY = rect.midY
    //
    //        switch edge {
    //        case .top:
    //            let start = CGPoint(x: midX - bumpSize, y: rect.minY)
    //            let end = CGPoint(x: midX + bumpSize, y: rect.minY)
    //            let control1 = CGPoint(x: midX - bumpSize / 2, y: invert ? rect.minY + bumpSize : rect.minY - bumpSize)
    //            let control2 = CGPoint(x: midX + bumpSize / 2, y: invert ? rect.minY + bumpSize : rect.minY - bumpSize)
    //            path.addLine(to: start)
    //            path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
    //            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    //        case .right:
    //            let start = CGPoint(x: rect.maxX, y: midY - bumpSize)
    //            let end = CGPoint(x: rect.maxX, y: midY + bumpSize)
    //            let control1 = CGPoint(x: invert ? rect.maxX - bumpSize : rect.maxX + bumpSize, y: midY - bumpSize / 2)
    //            let control2 = CGPoint(x: invert ? rect.maxX - bumpSize : rect.maxX + bumpSize, y: midY + bumpSize / 2)
    //            path.addLine(to: start)
    //            path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
    //            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
    //        case .bottom:
    //            let start = CGPoint(x: midX + bumpSize, y: rect.maxY)
    //            let end = CGPoint(x: midX - bumpSize, y: rect.maxY)
    //            let control1 = CGPoint(x: midX + bumpSize / 2, y: invert ? rect.maxY - bumpSize : rect.maxY + bumpSize)
    //            let control2 = CGPoint(x: midX - bumpSize / 2, y: invert ? rect.maxY - bumpSize : rect.maxY + bumpSize)
    //            path.addLine(to: start)
    //            path.addCurve(to: end, controlPoint1: control1, controlPoint2: control2)
    //            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    //        case .left:
    ////            let start = CGPoint(x: rect.minX, y: midY + bumpSize)
    //            let startSmallBump = CGPoint(x: rect.minX, y: midY + bumpSize / 2)
    //            let midSmallBump = CGPoint(x: rect.midX / 4 / 2, y: midY + bumpSize / 4)
    //            let endsmallBump = CGPoint(x: rect.midX / 4, y: midY + bumpSize / 2)
    //
    //            let startSmallBump2 = CGPoint(x: rect.midX / 4, y: midY - bumpSize / 2)
    //            let midSmallBump2 = CGPoint(x: rect.midX / 4 / 2, y: midY - bumpSize / 4)
    //            let endSmallBump2 = CGPoint(x: rect.minX, y: midY - bumpSize / 2)
    //
    //
    //            let midSmallBump3 = CGPoint(x: rect.midX / 2, y: midY / 2)
    //
    ////            path.addLine(to: start)
    //            path.addCurve(to: endsmallBump, controlPoint1: startSmallBump, controlPoint2: midSmallBump)
    //            path.addCurve(to: startSmallBump2, controlPoint1: endsmallBump, controlPoint2: midSmallBump3)
    //            path.addCurve(to: endSmallBump2, controlPoint1: startSmallBump2, controlPoint2: midSmallBump2)
    //        }
    //    }
}


import UIKit

class LineDrawingView: UIView {

    private var path = UIBezierPath()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        path.lineWidth = 2.0
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
    }

    override func draw(_ rect: CGRect) {

        UIColor.blue.setStroke()
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

        // Start the path and draw the lines
        path.move(to: firstLine)
        path.addLine(to: secondLine)

        let curve2 = CGPoint(x: midX + 15, y: (firstLine.y + secondLine.y) + 20)
        let endCurve = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y))
        path.move(to: secondLine)
        path.addCurve(to: endCurve, controlPoint1: secondLine, controlPoint2: curve2)

        let startCurve2 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y))
        let midCurve2 = CGPoint(x: midX + 60, y: (firstLine.y + secondLine.y) + 20)
        let endCurve2 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y) + 40)
        path.move(to: endCurve)
        path.addCurve(to: endCurve2, controlPoint1: startCurve2, controlPoint2: midCurve2)

        let startCurve3 = CGPoint(x: midX + 30, y: (firstLine.y + secondLine.y) + 40)

        let midCurve3 = CGPoint(x: midX + 15, y: (firstLine.y + secondLine.y) + 20)
        let endCurve3 = CGPoint(x: midX, y: (firstLine.y + secondLine.y) + 40)
        path.move(to: endCurve2)
        path.addCurve(to: endCurve3, controlPoint1: startCurve3, controlPoint2: midCurve3)

        path.move(to: endCurve3)
        path.addLine(to: CGPoint(x: midX, y: maxY))

        path.move(to: thirdLine)
        path.addLine(to: fourthLine)



        //            path.addArc(withCenter: centerPoint, radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true)

        path.stroke()
    }
}


struct LineDrawingViewRepresentable: UIViewRepresentable {

    func makeUIView(context: Context) -> LineDrawingView {
        let view = LineDrawingView()
        return view
    }

    func updateUIView(_ uiView: LineDrawingView, context: Context) {
    }
}
