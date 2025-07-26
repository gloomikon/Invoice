// swiftlint:disable:this file_name

import Core

enum CurrencyStorageKey: StorageKey {

    static let key = "currency"
    static var defaultValue: Currency = .usd
}
