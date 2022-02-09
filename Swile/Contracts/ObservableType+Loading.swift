//
//  ObservableType+Loading.swift
//  Swile
//
//  Created by Thomas Fromont on 09/02/2022.
//

import Foundation
import RxSwift

public protocol LoadingDataConvertible {
    /// Type of element in event
    associatedtype ElementType

    /// Event representation of this instance
    var data: Event<ElementType>? { get }
    var loading: Bool { get }
}

public struct LoadingResult<E>: LoadingDataConvertible {
    public let data: Event<E>?
    public let loading: Bool

    public init(_ loading: Bool) {
        self.data = nil
        self.loading = loading
    }

    public init(_ data: Event<E>) {
        self.data = data
        self.loading = false
    }

    public func map<T>(_ mapper: (E) -> T) -> LoadingResult<T> {
        if let data = data {
            return LoadingResult<T>(data.map(mapper))
        } else {
            return LoadingResult<T>(loading)
        }
    }
}

extension ObservableType {
    public func monitorLoading() -> Observable<LoadingResult<Element>> {
        return self.materialize()
            .map(LoadingResult.init)
            .startWith(LoadingResult(true))
    }
}

extension ObservableType where Element: LoadingDataConvertible {
    public func loading() -> Observable<Bool> {
        return self
            .map { $0.loading }
            .distinctUntilChanged()
    }

    public func data() -> Observable<Element.ElementType> {
        return self
            .events()
            .elements()
    }

    public func errors() -> Observable<Error> {
        return self
            .events()
            .errors()
    }

    /// Replay last 2 events (.next and .completed, .error and .completed)
    /// The result (ConnectableObservable) needs to be connected at some point.
    /// For more info, please read http://www.tailec.com/blog/understanding-publish-connect-refcount-share
    public func replayData() -> ConnectableObservable<Element> {
        return self.replay(2)
    }

    // MARK: - Private

    public func events() -> Observable<Event<Element.ElementType>> {
        return self
            .filter { !$0.loading }
            .map { $0.data }
            .unwrap()
    }
}
