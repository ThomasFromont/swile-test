//
//  TransfersViewModel.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import RxCocoa
import RxSwift
import RxSwiftExt

protocol TransfersViewModelDelegate: AnyObject {
    func didSelect(transfer: Transfer, from viewModel: TransfersViewModel)
}

final class TransfersViewModel {

    enum Cell {
        case header(HeaderCellViewModel)
    }

    // MARK: - Properties

    private let transfersProvider: TransfersProvider

    private let rx_reloadSubject = PublishSubject<Void>()
    private let rx_transferSubject = PublishSubject<Transfer>()
    private var disposeBag = DisposeBag()

    weak var delegate: TransfersViewModelDelegate?

    // MARK: - Inputs

    var rx_reloadObserver: AnyObserver<Void>?
    let rx_transferObserver: AnyObserver<Transfer>

    // MARK: - Outputs

    private(set) lazy var rx_loadingInitial: Driver<Bool> = rx_loadings
        .take(2)
        .asDriver(onErrorJustReturn: false)

    private(set) lazy var rx_loadingRefresh: Driver<Bool> = rx_loadings
        .skip(2)
        .distinctUntilChanged()
        .asDriver(onErrorJustReturn: false)

    private(set) lazy var rx_cells: Driver<[Cell]> = {
        rx_transfers
            .data()
            .map { [weak self] transfers in
                return self?.makeCells(transfers: transfers) ?? []
            }
            .asDriver(onErrorJustReturn: [])
    }()

    // MARK: - Initializers

    public init(transfersProvider: TransfersProvider) {
        self.transfersProvider = transfersProvider

        self.rx_reloadObserver = rx_reloadSubject.asObserver()
        self.rx_transferObserver = rx_transferSubject.asObserver()

        subscribeForDelegate()
    }

    private lazy var rx_transfers: Observable<LoadingResult<[Transfer]>> = {
        transfersProvider.rx_transfers.monitorLoading().share()
    }()

    private lazy var rx_loadings = rx_transfers
        .loading()
        .distinctUntilChanged()

    // MARK: - Delegate

    private func subscribeForDelegate() {
        rx_transferSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] transfer in
                guard let self = self else {
                    return
                }

                self.delegate?.didSelect(transfer: transfer, from: self)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Private

    private func makeCells(transfers: [Transfer]) -> [Cell] {
        let headerCell: [Cell] = [ .header(HeaderCellViewModel(title: L10n.Transfers.header)) ]
        let transfers = makeTransfersCell(transfers: transfers)
        return headerCell + transfers
    }

    private func makeTransfersCell(transfers: [Transfer]) -> [Cell] {
        // TODO: - Create Transfers Cells
        /*let transfers: [Cell] = transfers.map { transfer in
            let selectObserver = rx_transferObserver.mapObserver { transfer }
            return Cell.transfer(TransferCellViewModel(transfer: transfer, selectObserver: selectObserver))
        }

        return transfers*/
        return []
    }
}
