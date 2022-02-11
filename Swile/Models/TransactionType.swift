//
//  TransactionType.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

enum TransactionType: String, Decodable {
    case donation
    case gift
    case mealVoucher = "meal_voucher"
    case mobility
    case payment

    var name: String {
        switch self {
        case .donation: return L10n.Transaction.donationName
        case .gift: return L10n.Transaction.giftName
        case .mealVoucher: return L10n.Transaction.mealVoucherName
        case .mobility: return L10n.Transaction.mobilityName
        case .payment: return L10n.Transaction.paymentName
        }
    }
}
