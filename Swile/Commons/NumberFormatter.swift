//
//  NumberFormatter.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation

public protocol NumberFormatterType {
    func format(value: Double, minDigits: Int) -> String
}

public final class PriceFormatter: NumberFormatterType {

    private let formatter = Foundation.NumberFormatter()

    private var locale: Locale {
        return Locale.current
    }

    public func format(value: Double, minDigits: Int = 2) -> String {
        formatter.locale = locale
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? ""
    }
}
