//
//  MockTransactionsRepository.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
import RxSwift
@testable import Swile

class MockTransactionsRepository: TransactionsRepositoryType {

    private let transactions: [Transaction]

    init(transactions: [Transaction] = [.mock()]) {
        self.transactions = transactions
    }

    func get() -> Observable<[Transaction]> {
        return .just(transactions)
    }
}
