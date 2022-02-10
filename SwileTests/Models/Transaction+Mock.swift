//
//  Transaction+Mock.swift
//  SwileTests
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
@testable import Swile

extension Transaction {
    static func mock(
        name: String = "name",
        type: TransactionType = .gift,
        date: Date = Date(),
        message: String = "message",
        amount: Price = .init(value: 42, currency: .init(iso3: "EUR", symbol: "€", title: "euros")),
        smallIcon: Icon = .init(url: "url", category: .gift),
        largeIcon: Avatar = .init(url: "url", category: .sushi)
    ) -> Transaction {
        return Transaction(
            name: name,
            type: type,
            date: date,
            message: message,
            amount: amount,
            smallIcon: smallIcon,
            largeIcon: largeIcon
        )
    }
}
