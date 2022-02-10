//
//  MockTransactionsViewModelDelegate.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

@testable import Swile

class MockTransactionsViewModelDelegate: TransactionsViewModelDelegate {

    private let onSelect: ((Transaction) -> Void)?

    init(onSelect: ((Transaction) -> Void)? = nil) {
        self.onSelect = onSelect
    }

    func didSelect(transaction: Transaction, from: TransactionsViewModel) {
        onSelect?(transaction)
    }
}
