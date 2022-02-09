//
//  HasData.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import Foundation

protocol HasData: AnyObject {
    associatedtype Data
    var data: Data? { get set }
}
