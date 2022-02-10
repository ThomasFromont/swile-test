//
//  TransactionsRepository.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
import RxSwift

enum APIError: Error {
    case malformedURL
}

protocol TransactionsRepositoryType {
    func get() -> Observable<[Transaction]>
}

class TransactionsRepository: TransactionsRepositoryType {

    private enum Constant {
        static let url = "https://gist.githubusercontent.com"
            + "/Aurazion/365d587f5917d1478bf03bacabdc69f3/raw"
            + "/3c92b70e1dc808c8be822698f1cbff6c95ba3ad3/transactions.json"
    }
    func get() -> Observable<[Transaction]> {
        guard let url = URL(string: Constant.url) else {
            return Observable.error(APIError.malformedURL)
        }

        let request = URLRequest(url: url)

        return URLSession.shared.rx
            .response(request: request)
            .map { _, data in
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.apiFormat)
                let transactions = try decoder.decode(Transactions.self, from: data)
                return transactions.transactions
            }
    }
}

extension DateFormatter {
    static let apiFormat: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
