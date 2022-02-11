//
//  TransactionDetailsViewModel.swift
//  Swile
//
//  Created by Thomas Fromont on 11/02/2022.
//

import RxCocoa
import RxSwift

protocol TransactionDetailsViewModelDelegate: AnyObject {
    func didSelectClose(from: TransactionDetailsViewModel)
}

final class TransactionDetailsViewModel {

    typealias Action = (image: UIImage?, title: String, subtitle: String?, tint: Tint)

    // MARK: - Properties

    weak var delegate: TransactionDetailsViewModelDelegate?

    private let transaction: Transaction
    private let dateFormatter: DateFormatterType
    private let priceFormatter: NumberFormatterType
    private let imageProvider: ImageProviderType

    private let rx_closeSubject = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    let rx_closeObserver: AnyObserver<Void>

    // MARK: - Outputs

    let rx_icon: Driver<UIImage?>
    let rx_avatar: Driver<UIImage?>

    let tint: Tint
    let price: String
    let name: String
    let date: String
    let actions: [Action]
    let heroSuffix: String

    // MARK: - Initializers

    init(
        transaction: Transaction,
        dateFormatter: DateFormatterType,
        priceFormatter: NumberFormatterType,
        imageProvider: ImageProviderType
    ) {
        self.transaction = transaction
        self.dateFormatter = dateFormatter
        self.priceFormatter = priceFormatter
        self.imageProvider = imageProvider

        rx_closeObserver = rx_closeSubject.asObserver()

        rx_icon = imageProvider
            .rx_image(
                from: transaction.smallIcon.url,
                defaultImage: transaction.smallIcon.category.image
            )
            .asDriver(onErrorDriveWith: .never())

        rx_avatar = imageProvider
            .rx_image(
                from: transaction.largeIcon.url,
                defaultImage: transaction.largeIcon.category.image
            )
            .asDriver(onErrorDriveWith: .never())

        tint = transaction.smallIcon.category.tint

        let isPriceNegative = transaction.amount.value < 0
        let priceFormatted = priceFormatter.format(value: transaction.amount.value, minDigits: 2)
            + transaction.amount.currency.symbol
        price = isPriceNegative ? priceFormatted : "+" + priceFormatted

        name = transaction.name
        date = dateFormatter.formatFullRelative(date: transaction.date, relativeTo: Date())

        heroSuffix = [transaction.name, String(transaction.date.timeIntervalSince1970)]
            .joined(separator: "_")

        actions = [
            (transaction.smallIcon.category.image, transaction.type.name, L10n.Transaction.changeAccount, tint: transaction.smallIcon.category.tint),
            (Asset.iconShare.image.withRenderingMode(.alwaysTemplate), L10n.Transaction.share, nil, tint: .neutral),
            (Asset.iconLove.image.withRenderingMode(.alwaysTemplate), L10n.Transaction.love, nil, tint: .neutral),
            (Asset.iconQuestion.image.withRenderingMode(.alwaysTemplate), L10n.Transaction.help, nil, tint: .neutral),
        ]

        bindDelegate()
    }

    // MARK: - Delegate

    private func bindDelegate() {
        rx_closeSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.delegate?.didSelectClose(from: self)
            })
            .disposed(by: disposeBag)
    }
}
