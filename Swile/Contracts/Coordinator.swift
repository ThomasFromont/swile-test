//
//  Coordinator.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

public protocol Coordinator: AnyObject {
    func start()
    func close(animated: Bool, completion: (() -> Void)?)
}
