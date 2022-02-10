//
//  TransactionsViewModel.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import RxCocoa
import RxSwift
import RxSwiftExt

protocol TransactionsViewModelDelegate: AnyObject {
    func didSelect(transaction: Transaction, from viewModel: TransactionsViewModel)
}

final class TransactionsViewModel {

    enum Cell {
        case header(HeaderCellViewModel)
    }

    // MARK: - Properties

    private let transactionsProvider: TransactionsProviderType

    private let rx_reloadSubject = PublishSubject<Void>()
    private let rx_transactionSubject = PublishSubject<Transaction>()
    private var disposeBag = DisposeBag()

    weak var delegate: TransactionsViewModelDelegate?

    // MARK: - Inputs

    var rx_reloadObserver: AnyObserver<Void>?
    let rx_transactionObserver: AnyObserver<Transaction>

    // MARK: - Outputs

    private(set) lazy var rx_loadingInitial: Driver<Bool> = rx_loadings
        .take(2)
        .asDriver(onErrorJustReturn: false)

    private(set) lazy var rx_loadingRefresh: Driver<Bool> = rx_loadings
        .skip(2)
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)

    private(set) lazy var rx_cells: Driver<[Cell]> = {
        rx_transactions
            .data()
            .map { [weak self] transactions in
                return self?.makeCells(transactions: transactions) ?? []
            }
            .asDriver(onErrorJustReturn: [])
    }()

    // MARK: - Initializers

    public init(transactionsProvider: TransactionsProviderType) {
        self.transactionsProvider = transactionsProvider

        self.rx_reloadObserver = rx_reloadSubject.asObserver()
        self.rx_transactionObserver = rx_transactionSubject.asObserver()

        subscribeForDelegate()
    }

    private lazy var rx_transactions: Observable<LoadingResult<[Transaction]>> = {
        transactionsProvider.rx_transactions.monitorLoading().share()
    }()

    private lazy var rx_loadings = rx_transactions
        .loading()
        .distinctUntilChanged()

    // MARK: - Delegate

    private func subscribeForDelegate() {
        rx_transactionSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] transaction in
                guard let self = self else {
                    return
                }

                self.delegate?.didSelect(transaction: transaction, from: self)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private

    private func makeCells(transactions: [Transaction]) -> [Cell] {
        let headerCell: [Cell] = [ .header(HeaderCellViewModel(title: L10n.Transactions.header)) ]
        let transactions = makeTransactionsCell(transactions: transactions)
        return headerCell + transactions
    }

    private func makeTransactionsCell(transactions: [Transaction]) -> [Cell] {
        // TODO: - Create Transactions Cells
        /*let transactions: [Cell] = transactions.map { transaction in
            let selectObserver = rx_transactionObserver.mapObserver { transaction }
            return Cell.transaction(TransactionCellViewModel(transaction: transaction, selectObserver: selectObserver))
        }

        return transactions*/
        return []
    }
}
