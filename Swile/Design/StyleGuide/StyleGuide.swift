//
//  StyleGuide.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

protocol StyleGuideType: AnyObject {
    var colorScheme: ColorSchemeType { get }
    var fontBook: FontBookType { get }
}

final class StyleGuide: StyleGuideType {

    static let shared = StyleGuide()

    private var _colorScheme: ColorSchemeType = ColorScheme()
    var colorScheme: ColorSchemeType {
        return _colorScheme
    }

    private var _fontBook: FontBookType = FontBook()
    var fontBook: FontBookType {
        return _fontBook
    }
}
