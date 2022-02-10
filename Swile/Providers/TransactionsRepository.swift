//
//  TransactionsRepository.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation
import RxSwift

enum APIError: Error {
    case unexpectedStatusCode
    case dataEmpty
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
            return .never()
        }

        return Observable.create { observer in
            let task = URLSession.shared.dataTask(
                with: url,
                completionHandler: { data, response, error in
                    if let error = error {
                        observer.onError(error)
                        observer.onCompleted()
                        return
                    }

                    guard
                        let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode)
                    else {
                        observer.onError(APIError.unexpectedStatusCode)
                        observer.onCompleted()
                        return
                    }

                    guard let data = data else {
                        observer.onError(APIError.dataEmpty)
                        observer.onCompleted()
                        return
                    }

                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                    do {
                        let transactions = try decoder.decode(Transactions.self, from: data)
                        observer.onNext(transactions.transactions)
                        observer.onCompleted()
                        return
                    } catch let error {
                        observer.onError(error)
                        observer.onCompleted()
                        return
                    }
                }
            )
            task.resume()
            return Disposables.create()
        }
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
