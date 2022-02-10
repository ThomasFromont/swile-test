//
//  IconCategory.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

enum IconCategory: String, Decodable {
    case gift
    case mealVoucher = "meal_voucher"
    case mobility
    case payment

    // TODO: - Payment Icon missing in Figma
    var image: UIImage {
        switch self {
        case .gift: return Asset.iconGift.image.withRenderingMode(.alwaysTemplate)
        case .mealVoucher: return Asset.iconMealVoucher.image.withRenderingMode(.alwaysTemplate)
        case .mobility: return Asset.iconMobility.image.withRenderingMode(.alwaysTemplate)
        case .payment: return UIImage()
        }
    }

    var tint: Tint {
        switch self {
        case .gift: return .gift
        case .mealVoucher: return .mealVoucher
        case .mobility: return .mobility
        case .payment: return .payment
        }
    }
}
