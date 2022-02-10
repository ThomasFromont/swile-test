//
//  FontBook.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit
import Foundation

protocol FontBookType: AnyObject {
    var header: UIFont { get }
}

class FontBook: FontBookType {

    var header: UIFont { return font(of: 30, with: UIFont.Weight.bold) }

    // MARK: - Private

    private func font(of size: CGFloat, with weight: UIFont.Weight) -> UIFont {
        let segmaFont = SegmaFont.of(weight: weight)
        if !UIFont.fontNames(forFamilyName: Constant.fontFamilyName).contains(segmaFont.rawValue) {
            register(font: segmaFont)
        }

        return UIFont(name: segmaFont.rawValue, size: size) ?? UIFont.systemFont(ofSize: size, weight: weight)
    }

    // MARK: - Private

    private func register(font: SegmaFont) {
        let bundle = Bundle(for: FontBook.self)

        let fontURL = bundle.url(forResource: font.rawValue, withExtension: Constant.fontExtension)
        let cgDataProvider = fontURL.flatMap { CGDataProvider(url: $0 as CFURL) }
        if let cgFont = cgDataProvider.flatMap({ CGFont($0) }) {
            CTFontManagerRegisterGraphicsFont(cgFont, nil)
        }
    }

    private enum Constant {
        static let fontFamilyName = "Segma"
        static let fontExtension = "otf"
    }

    private enum SegmaFont: String {
        case medium = "Segma-Medium"
        case semiBold = "Segma-SemiBold"
        case bold = "Segma-Bold"

        static func of(weight: UIFont.Weight) -> SegmaFont {
            switch weight {
            case UIFont.Weight.medium:
                return SegmaFont.medium
            case UIFont.Weight.semibold:
                return SegmaFont.semiBold
            case UIFont.Weight.bold:
                return SegmaFont.bold
            default:
                return SegmaFont.medium
            }
        }
    }
}
