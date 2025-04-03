//
//  Typography.swift
//  RickAndMorty
//
//  Created by Dio Putra Utama on 15/08/24.
//

import SwiftUI

enum FontType: String, CaseIterable {
    case light            = "NotoSans-Light"     // 300
    case regular          = "NotoSans-Regular"   // 400
    case medium           = "NotoSans-Medium"    // 500
    case semiBold         = "NotoSans-SemiBold"  // 600
    case bold             = "NotoSans-Bold"      // 700
    case extraBold        = "NotoSans-ExtraBold" // 800
}

class Typography {
    // 12
    static let size12: Font = .custom(FontType.light.rawValue, size: 12)
    static let size12Bold: Font = .custom(FontType.bold.rawValue, size: 12) 

    // 14
    static let size14: Font = .custom(FontType.light.rawValue, size: 14)
    static let size14Bold: Font = .custom(FontType.bold.rawValue, size: 14)

    // 16
    static let size16: Font = .custom(FontType.light.rawValue, size: 16)
    static let size16Bold: Font = .custom(FontType.bold.rawValue, size: 16)

    static func customFont(font: FontType, size: CGFloat) -> Font {
        return .custom(font.rawValue, size: size)
    }
}
