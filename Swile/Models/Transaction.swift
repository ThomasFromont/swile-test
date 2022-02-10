//
//  Transaction.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import Foundation
import RxSwift
import QuartzCore

struct Transactions: Decodable {
    let transactions: [Transaction]
}

struct Transaction: Decodable {
    let name: String
    let type: TransactionType
    let date: Date
    let message: String?
    let amount: Price
    let smallIcon: Icon
    let largeIcon: Avatar

    enum TransactionType: String, Decodable {
    case donation
    case gift
    case mealVoucher = "meal_voucher"
    case mobility
    case payment
    }

    struct Price: Decodable {
        let value: Double
        let currency: Currency
    }

    struct Currency: Decodable {
        let iso3: String
        let symbol: String
        let title: String
    }

    struct Icon: Decodable {
        let url: String?
        let category: IconCategory
    }

    struct Avatar: Decodable {
        let url: String?
        let category: AvatarCategory
    }
}
