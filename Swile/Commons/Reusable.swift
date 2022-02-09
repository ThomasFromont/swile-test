//
//  Reusable.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import UIKit

public protocol Reusable: AnyObject {
    var reusableIdentifier: String { get }
    static var reusableIdentifier: String { get }
}

extension UITableViewCell: Reusable {
    public var reusableIdentifier: String { return String(describing: self) }
    public static var reusableIdentifier: String { return String(describing: self) }
}

extension UITableView {
    // Allowing UITableView class registration with Reusable
    public func registerReusable<T: Reusable>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reusableIdentifier)
    }

    // Safely dequeue a `Reusable` item
    public func dequeueReusableCell<T: Reusable>(withCellClass cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reusableIdentifier) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }

        return cell
    }

    // Safely dequeue a `Reusable` item for a given index path
    public func dequeueReusableCell<T: Reusable>(withCellClass cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }

        return cell
    }
}

extension UICollectionViewCell: Reusable {
    public var reusableIdentifier: String { return String(describing: self) }
    public static var reusableIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    public func register<T: Reusable>(_: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
    }

    public func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }

        return cell
    }
}
