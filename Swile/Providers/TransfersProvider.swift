//
//  TransfersProvider.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import Foundation
import RxSwift

protocol TransfersProvider {
    var rx_transfers: Observable<[Transfer]> { get }
}

class TransfersProviderExample: TransfersProvider {
    var rx_transfers: Observable<[Transfer]> = .just([])
}
