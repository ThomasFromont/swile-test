//
//  ColorScheme.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import UIKit

protocol ColorSchemeType: AnyObject {
    var background: UIColor { get }
    var divider: UIColor { get }

    var textPrimary: UIColor { get }
    var textSecondary: UIColor { get }

    var tintGiftLight: UIColor { get }
    var tintGiftDark: UIColor { get }
    var tintMealVoucherLight: UIColor { get }
    var tintMealVoucherDark: UIColor { get }
    var tintMobilityLight: UIColor { get }
    var tintMobilityDark: UIColor { get }
    var tintPaymentLight: UIColor { get }
    var tintPaymentDark: UIColor { get }
}

class ColorScheme: ColorSchemeType {

    private enum ColorPalette {
        static let black: UInt32 = 0x000000
        static let grey100: UInt32 = 0xE8E7EC
        static let grey300: UInt32 = 0xEEEDF1
        static let grey700: UInt32 = 0x918BA6
        static let grey900: UInt32 = 0x1D1148
        static let orange300: UInt32 = 0xFFEBD4
        static let orange500: UInt32 = 0xFD9B28
        static let pink300: UInt32 = 0xFEE0F0
        static let pink500: UInt32 = 0xFC63B6
        static let purple300: UInt32 = 0xE6E0F8
        static let purple500: UInt32 = 0x633FD3
        static let red300: UInt32 = 0xFEE0E1
        static let red500: UInt32 = 0xFC636B
        static let white: UInt32 = 0xFFFFFF
    }

    // MARK: - ColorSchemeType

    var background: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.white, darkHex: ColorPalette.black)
    }
    var divider: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.grey300, darkHex: ColorPalette.grey700)
    }

    var textPrimary: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.grey900, darkHex: ColorPalette.grey100)
    }
    var textSecondary: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.grey700, darkHex: ColorPalette.grey300)
    }

    var tintGiftLight: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.pink300, darkHex: ColorPalette.pink300)
    }
    var tintGiftDark: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.pink500, darkHex: ColorPalette.pink500)
    }
    var tintMealVoucherLight: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.orange300, darkHex: ColorPalette.orange300)
    }
    var tintMealVoucherDark: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.orange500, darkHex: ColorPalette.orange500)
    }
    var tintMobilityLight: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.red300, darkHex: ColorPalette.red300)
    }
    var tintMobilityDark: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.red500, darkHex: ColorPalette.red500)
    }
    var tintPaymentLight: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.purple300, darkHex: ColorPalette.purple300)
    }
    var tintPaymentDark: UIColor {
        return ColorScheme.color(lightHex: ColorPalette.purple500, darkHex: ColorPalette.purple500)
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
