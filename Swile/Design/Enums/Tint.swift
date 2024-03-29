//
//  Tint.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

public enum Tint {
    case gift
    case mealVoucher
    case mobility
    case neutral
    case payment

    var lightColor: UIColor {
        switch self {
        case .gift: return StyleGuide.shared.colorScheme.tintGiftLight
        case .mealVoucher: return StyleGuide.shared.colorScheme.tintMealVoucherLight
        case .mobility: return StyleGuide.shared.colorScheme.tintMobilityLight
        case .neutral: return StyleGuide.shared.colorScheme.tintNeutralLight
        case .payment: return StyleGuide.shared.colorScheme.tintPaymentLight
        }
    }

    var darkColor: UIColor {
        switch self {
        case .gift: return StyleGuide.shared.colorScheme.tintGiftDark
        case .mealVoucher: return StyleGuide.shared.colorScheme.tintMealVoucherDark
        case .mobility: return StyleGuide.shared.colorScheme.tintMobilityDark
        case .neutral: return StyleGuide.shared.colorScheme.tintNeutralDark
        case .payment: return StyleGuide.shared.colorScheme.tintPaymentDark
        }
    }
}
