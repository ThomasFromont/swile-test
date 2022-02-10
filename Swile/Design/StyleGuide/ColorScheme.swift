//
//  ColorScheme.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit

protocol ColorSchemeType: AnyObject {
    var background: UIColor { get }
    var textPrimary: UIColor { get }
}

class ColorScheme: ColorSchemeType {

    private enum ColorPalette {
        static let black: UInt32 = 0x000000
        static let grey100: UInt32 = 0xE8E7EC
        static let grey900: UInt32 = 0x1D1148
        static let white: UInt32 = 0xFFFFFF
    }

    // MARK: - ColorSchemeType

    var background: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.white, darkHex: ColorPalette.black)
    }

    var textPrimary: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.grey900, darkHex: ColorPalette.grey100)
    }
}

private extension ColorScheme {

    static func color(lightHex: UInt32, darkHex: UInt32) -> UIColor {
        if #available(iOS 12, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                let darkColor = UIColor(hex: darkHex)
                let lightColor = UIColor(hex: lightHex)
                return traitCollection.userInterfaceStyle == .dark ? darkColor : lightColor
            }
        } else {
            return UIColor(hex: lightHex)
        }
    }
}

private extension UIColor {
    convenience init(hex: UInt32) {
        let divisor = CGFloat(255)
        let red = CGFloat((hex & 0xFF0000) >> 16) / divisor
        let green = CGFloat((hex & 0x00FF00) >> 8) / divisor
        let blue = CGFloat(hex & 0x0000FF) / divisor
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
