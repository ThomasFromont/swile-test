//
//  MockTransactionDetailsViewModelDelegate.swift
//  SwileTests
//
//  Created by Thomas Fromont on 11/02/2022.
//

@testable import Swile

class MockTransactionDetailsViewModelDelegate: TransactionDetailsViewModelDelegate {

    private let onSelectClose: (() -> Void)?

    init(onSelectClose: (() -> Void)? = nil) {
        self.onSelectClose = onSelectClose
    }

    func didSelectClose(from: TransactionDetailsViewModel) {
        onSelectClose?()
    }
}
