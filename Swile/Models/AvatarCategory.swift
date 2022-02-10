//
//  AvatarCategory.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

enum AvatarCategory: String, Decodable {
    case bakery
    case burger
    case computer
    case donation
    case payment
    case supermarket
    case sushi
    case train

    // TODO: - Payment/Donation Avatar missing in Figma
    var image: UIImage {
        switch self {
        case .bakery: return Asset.avatarBakery.image.withRenderingMode(.alwaysTemplate)
        case .burger: return Asset.avatarBurger.image.withRenderingMode(.alwaysTemplate)
        case .computer: return Asset.avatarComputer.image.withRenderingMode(.alwaysTemplate)
        case .donation: return UIImage()
        case .payment: return UIImage()
        case .supermarket: return Asset.avatarSupermarket.image.withRenderingMode(.alwaysTemplate)
        case .sushi: return Asset.avatarSushi.image.withRenderingMode(.alwaysTemplate)
        case .train: return Asset.avatarTrain.image.withRenderingMode(.alwaysTemplate)
        }
    }
}
