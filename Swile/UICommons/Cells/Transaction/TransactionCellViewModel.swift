//
//  TransactionCellViewModel.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import RxCocoa
import RxSwift

final class TransactionCellViewModel {

    // MARK: - Outputs

    let title: String
    let subtitle: String
    let isPriceNegative: Bool
    let price: String
    let tint: Tint

    let rx_icon: Driver<UIImage?>
    let rx_avatar: Driver<UIImage?>

    let selectObserver: AnyObserver<Void>

    // MARK: - Initializers

    init(
        transaction: Transaction,
        dateFormatter: DateFormatterType,
        priceFormatter: NumberFormatterType,
        selectObserver: AnyObserver<Void>
    ) {
        self.title = transaction.name
        let date = dateFormatter.formatDayMonth(date: transaction.date)
        var subtitle = date
        if let message = transaction.message {
            subtitle += " · " + message
        }
        self.subtitle = subtitle
        self.isPriceNegative = transaction.amount.value < 0
        let minDigits = isPriceNegative ? 2 : 0
        var price = priceFormatter.format(value: transaction.amount.value, minDigits: minDigits)
            + transaction.amount.currency.symbol
        price = isPriceNegative
            ? price
            : "+" + price
        self.price = price
        self.tint = transaction.smallIcon.category.tint
        self.selectObserver = selectObserver

        self.rx_icon = ImageProvider
            .rx_image(
                from: transaction.smallIcon.url,
                defaultImage: transaction.smallIcon.category.image
            )
            .asDriver(onErrorDriveWith: .never())

        self.rx_avatar = ImageProvider
            .rx_image(
                from: transaction.largeIcon.url,
                defaultImage: transaction.largeIcon.category.image
            )
            .asDriver(onErrorDriveWith: .never())
    }
}
