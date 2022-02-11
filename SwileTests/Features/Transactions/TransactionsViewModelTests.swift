//
//  TransactionsViewModelTests.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

import XCTest
import RxSwift
@testable import Swile

class TransactionsViewModelTests: XCTestCase {

    private let dateFormatter = Swile.DateFormatter()
    private let disposeBag = DisposeBag()

    func testDelegate() {
        let transaction = Transaction.mock()

        let condition: (TransactionsViewModel.Cell) -> Bool = { cell in
            guard case .transaction = cell else {
                return false
            }
            return true
        }

        let expectCells = expectation(description: "Cells should trigger")
        let expectTransaction = expectation(description: "Select transaction delegate method should trigger")

        let delegate = MockTransactionsViewModelDelegate(
            onSelect: { someTransaction in
                XCTAssertEqual(someTransaction.name, transaction.name)
                expectTransaction.fulfill()
            }
        )

        let viewModel = TransactionsViewModel.mock(
            transactionsRepository: MockTransactionsRepository(transactions: [transaction])
        )
        viewModel.delegate = delegate

        var transactionCell: TransactionsViewModel.Cell?
        viewModel
            .rx_cells
            .drive(onNext: { cells in
                expectCells.fulfill()
                transactionCell = cells.first(where: { condition($0) })
            })
            .disposed(by: disposeBag)

        viewModel.rx_reloadObserver.onNext(())
        wait(for: [expectCells], timeout: XCTestCase.defaultTimeout)

        guard let notNilCell = transactionCell, case .transaction(let transactionCellViewModel) = notNilCell else {
            return XCTFail("Wrong cell type")
        }

        transactionCellViewModel.selectObserver.onNext(())
        wait(for: [expectTransaction], timeout: XCTestCase.defaultTimeout)
    }

    func testLoading() {
        let expectationInitial = self.expectation(description: "initial loading")
        expectationInitial.expectedFulfillmentCount = 2
        let expectationRefresh = self.expectation(description: "refresh loading")
        expectationRefresh.expectedFulfillmentCount = 2

        let viewModel = TransactionsViewModel.mock()

        let expectedLoading = [true, false]
        var recordedInitialLoading = [Bool]()
        var recordedRefreshLoading = [Bool]()

        viewModel
            .rx_loadingInitial
            .drive(onNext: { loading in
                expectationInitial.fulfill()
                recordedInitialLoading.append(loading)
            })
            .disposed(by: disposeBag)

        viewModel
            .rx_loadingRefresh
            .drive(onNext: { loading in
                expectationRefresh.fulfill()
                recordedRefreshLoading.append(loading)
            })
            .disposed(by: disposeBag)

        viewModel.rx_reloadObserver.onNext(())
        wait(for: [expectationInitial], timeout: XCTestCase.defaultTimeout)
        XCTAssertEqual(recordedInitialLoading, expectedLoading)

        viewModel.rx_reloadObserver.onNext(())
        wait(for: [expectationRefresh], timeout: XCTestCase.defaultTimeout)
        XCTAssertEqual(recordedRefreshLoading, expectedLoading)
    }

    func testHeaderCell() {
        let cells = recordedCells()

        guard
            cells.count > 0,
            case .header(let viewModel) = cells[0]
        else {
            return XCTFail("Wrong cell type")
        }

        XCTAssertEqual(viewModel.title, L10n.Transactions.header)
    }

    func testSectionHeaderCell() {
        let date = Date()
        let transaction = Transaction.mock(date: date)
        let cells = recordedCells(transactions: [transaction])

        let expectedTitle = dateFormatter.formatMonthYearRelative(date: date, relativeTo: Date())

        guard
            cells.count > 0,
            case .header = cells[0],
            case .spacing = cells[1],
            case .section(let viewModel) = cells[2]
        else {
            return XCTFail("Wrong cell type")
        }

        XCTAssertEqual(viewModel.title, expectedTitle)
    }

    func testTransactionCell() {
        let name = "🐼"
        let transaction = Transaction.mock(name: name)
        let cells = recordedCells(transactions: [transaction])

        guard
            cells.count > 0,
            case .header = cells[0],
            case .spacing = cells[1],
            case .section = cells[2],
            case .transaction(let viewModel) = cells[3]
        else {
            return XCTFail("Wrong cell type")
        }

        XCTAssertEqual(viewModel.title, name)
    }

    func testTransactionSameMonth() {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let firstDate = formatter.date(from: "10/02/2022")
        let firstName = "first_name"
        let secondDate = formatter.date(from: "11/02/2022")
        let secondName = "second_name"

        guard let firstDate = firstDate, let secondDate = secondDate else {
            return XCTFail("Date init failed")
        }

        let firstTransaction = Transaction.mock(name: firstName, date: firstDate)
        let secondTransaction = Transaction.mock(name: secondName, date: secondDate)
        let cells = recordedCells(transactions: [firstTransaction, secondTransaction])

        guard
            cells.count > 0,
            case .header = cells[0],
            case .spacing = cells[1],
            case .section = cells[2],
            case .transaction(let firstViewModel) = cells[3],
            case .spacing = cells[4],
            case .transaction(let secondViewModel) = cells[5],
            case .spacing = cells[6]
        else {
            return XCTFail("Wrong cell type")
        }

        // Transactions should be reordered by date
        XCTAssertEqual(firstViewModel.title, secondName)
        XCTAssertEqual(secondViewModel.title, firstName)
    }

    func testTransactionDifferentMonth() {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let firstDate = formatter.date(from: "10/01/2022")
        let firstName = "first_name"
        let secondDate = formatter.date(from: "11/02/2022")
        let secondName = "second_name"

        guard let firstDate = firstDate, let secondDate = secondDate else {
            return XCTFail("Date init failed")
        }

        let firstTransaction = Transaction.mock(name: firstName, date: firstDate)
        let secondTransaction = Transaction.mock(name: secondName, date: secondDate)
        let cells = recordedCells(transactions: [firstTransaction, secondTransaction])

        let expectedFirstSectionTitle = dateFormatter.formatMonthYearRelative(
            date: secondDate,
            relativeTo: Date()
        )
        let expectedSecondSectionTitle = dateFormatter.formatMonthYearRelative(
            date: firstDate,
            relativeTo: Date()
        )

        guard
            cells.count > 0,
            case .header = cells[0],
            case .spacing = cells[1],
            case .section(let firstSectionViewModel) = cells[2],
            case .transaction(let firstViewModel) = cells[3],
            case .spacing = cells[4],
            case .spacing = cells[5],
            case .section(let secondSectionViewModel) = cells[6],
            case .transaction(let secondViewModel) = cells[7],
            case .spacing = cells[8]
        else {
            return XCTFail("Wrong cell type")
        }

        // Transactions should be reordered by date
        XCTAssertEqual(firstViewModel.title, secondName)
        XCTAssertEqual(secondViewModel.title, firstName)
        XCTAssertEqual(firstSectionViewModel.title, expectedFirstSectionTitle)
        XCTAssertEqual(secondSectionViewModel.title, expectedSecondSectionTitle)
    }

    private func recordedCells(transactions: [Transaction] = [.mock()]) -> [TransactionsViewModel.Cell] {
        let expectation = self.expectation(description: "cells")

        let transactionsRepository = MockTransactionsRepository(transactions: transactions)
        let viewModel = TransactionsViewModel.mock(transactionsRepository: transactionsRepository)

        var recordedCells: [TransactionsViewModel.Cell] = []

        viewModel
            .rx_cells
            .drive(onNext: { cells in
                expectation.fulfill()
                recordedCells = cells
            })
            .disposed(by: disposeBag)

        viewModel.rx_reloadObserver.onNext(())
        waitForExpectationsWithDefaultTimeout()

        return recordedCells
    }
}
