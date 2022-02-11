//
//  DateFormatter.swift
//  Swile
//
//  Created by Thomas Fromont on 10/02/2022.
//

import Foundation

public protocol DateFormatterType {
    func formatDayMonth(date: Date) -> String
    func formatMonthYearRelative(date: Date, relativeTo referenceDate: Date) -> String
    func formatFullRelative(date: Date, relativeTo referenceDate: Date) -> String
}

public final class DateFormatter: DateFormatterType {

    private var formattersCachedByDateFormat: [String: Foundation.DateFormatter] = [:]
    private let queue = DispatchQueue(label: "swile.dateformatter", qos: DispatchQoS.userInteractive)

    private let calendar: Calendar = .current
    private var locale: Locale {
        return Locale.current
    }

    public func formatDayMonth(date: Date) -> String {
        return dateFormatter(for: .dayMonth).string(from: date)
    }

    public func formatMonthYearRelative(date: Date, relativeTo referenceDate: Date) -> String {
        let shouldIncludeYear = !calendar.isDate(date, equalTo: referenceDate, toGranularity: .year)

        let dateFormat: DateFormat = shouldIncludeYear ? .monthYear : .month
        return dateFormatter(for: dateFormat).string(from: date)
    }

    public func formatFullRelative(date: Date, relativeTo referenceDate: Date) -> String {
        let shouldIncludeYear = !calendar.isDate(date, equalTo: referenceDate, toGranularity: .year)

        let dateFormat: DateFormat = shouldIncludeYear ? .fullWithYear : .fullWithoutYear
        return dateFormatter(for: dateFormat).string(from: date)
    }

    private func dateFormatter(for dateFormat: DateFormat) -> Foundation.DateFormatter {
        let dateFormatString = dateFormat.translation

        var formatter: Foundation.DateFormatter?
        queue.sync {
            if let cachedFormatter = formattersCachedByDateFormat[dateFormatString] {
                formatter = cachedFormatter
            } else {
                formatter = Foundation.DateFormatter()
                formatter?.locale = locale
                formatter?.dateFormat = dateFormatString
                formattersCachedByDateFormat[dateFormatString] = formatter
            }
        }

        return formatter ?? .init()
    }
}

private enum DateFormat {
    case dayMonth
    case fullWithoutYear
    case fullWithYear
    case month
    case monthYear

    var translation: String {
        switch self {
        case .dayMonth: return L10n.DateFormat.dayMonth
        case .fullWithoutYear: return L10n.DateFormat.fullWithoutYear
        case .fullWithYear: return L10n.DateFormat.fullWithYear
        case .month: return L10n.DateFormat.month
        case .monthYear: return L10n.DateFormat.monthYear
        }
    }
}
