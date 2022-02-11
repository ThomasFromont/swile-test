//
//  TransactionViewModel+Mock.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

@testable import Swile

extension TransactionsViewModel {
    static func mock(
        transactionsRepository: TransactionsRepositoryType = MockTransactionsRepository()
    ) -> TransactionsViewModel {
        return TransactionsViewModel(
            transactionsRepository: transactionsRepository,
            dateFormatter: DateFormatter(),
            priceFormatter: PriceFormatter(),
            imageProvider: ImageProvider()
        )
    }
}
