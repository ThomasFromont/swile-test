//
//  TransactionsProvider.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import Foundation
import RxSwift

protocol TransactionsProviderType {
    var rx_transactions: Observable<[Transaction]> { get }
}

class TransactionsProvider: TransactionsProviderType {

    let transactionsRepository: TransactionsRepositoryType

    init(transactionsRepository: TransactionsRepositoryType = TransactionsRepository()) {
        self.transactionsRepository = transactionsRepository
    }

    var rx_transactions: Observable<[Transaction]> {
        return transactionsRepository.get().share()
    }
}
