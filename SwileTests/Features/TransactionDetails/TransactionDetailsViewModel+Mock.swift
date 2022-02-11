//
//  TransactionDetailsViewModel+Mock.swift
//  SwileTests
//
//  Created by Thomas Fromont on 11/02/2022.
//

@testable import Swile

extension TransactionDetailsViewModel {
    static func mock(
        transaction: Transaction = .mock()
    ) -> TransactionDetailsViewModel {
        return TransactionDetailsViewModel(
            transaction: transaction,
            dateFormatter: DateFormatter(),
            priceFormatter: PriceFormatter(),
            imageProvider: ImageProvider()
        )
    }
}
