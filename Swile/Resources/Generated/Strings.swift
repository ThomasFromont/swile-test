// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum DateFormat {
    /// dd MMMM
    internal static let dayMonth = L10n.tr("Localizable", "date_format.day_month")
    /// EEEE dd MMMM yyyy, HH:mm
    internal static let fullWithYear = L10n.tr("Localizable", "date_format.full_with_year")
    /// EEEE dd MMMM, HH:mm
    internal static let fullWithoutYear = L10n.tr("Localizable", "date_format.full_without_year")
    /// MMMM
    internal static let month = L10n.tr("Localizable", "date_format.month")
    /// MMMM yyyy
    internal static let monthYear = L10n.tr("Localizable", "date_format.month_year")
  }

  internal enum Transactions {
    /// Meal vouchers
    internal static let header = L10n.tr("Localizable", "transactions.header")
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
