//
//  TransactionDetailsViewModelTests.swift
//  SwileTests
//
//  Created by Thomas Fromont on 11/02/2022.
//

import XCTest
@testable import Swile

class TransactionDetailsViewModelTests: XCTestCase {

    private let dateFormatter = Swile.DateFormatter()

    func testDelegate() {
        let expectClose = expectation(description: "Select close delegate method should trigger")

        let delegate = MockTransactionDetailsViewModelDelegate(
            onSelectClose: {
                expectClose.fulfill()
            }
        )

        let viewModel = TransactionDetailsViewModel.mock()
        viewModel.delegate = delegate

        viewModel.rx_closeObserver.onNext(())
        waitForExpectationsWithDefaultTimeout()
    }

    func testActions() {
        let type = TransactionType.mobility
        let transaction = Transaction.mock(type: type)
        let viewModel = TransactionDetailsViewModel.mock(transaction: transaction)

        XCTAssertEqual(viewModel.actions.count, 4)
        XCTAssertEqual(viewModel.actions[0].title, type.name)
        XCTAssertEqual(viewModel.actions[0].subtitle, L10n.Transaction.changeAccount)
        XCTAssertEqual(viewModel.actions[1].title, L10n.Transaction.share)
        XCTAssertNil(viewModel.actions[1].subtitle)
        XCTAssertEqual(viewModel.actions[2].title, L10n.Transaction.love)
        XCTAssertNil(viewModel.actions[2].subtitle)
        XCTAssertEqual(viewModel.actions[3].title, L10n.Transaction.help)
        XCTAssertNil(viewModel.actions[3].subtitle)
    }
}
