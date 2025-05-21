import Combine
import SwiftUI

public protocol StorageKey {
    associatedtype Value: Codable

    static var key: String { get }
    static var defaultValue: Value { get }
}

@propertyWrapper
public struct Storage<Value: Codable>: DynamicProperty {

    @ObservedObject private var pinger: Pinger

    private let defaultValue: Value
    private let userDefaults: UserDefaults?
    private let key: String

    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private let subject = CurrentValueSubject<Value?, Never>(nil)

    public init(_ key: String, default: Value, userDefaults: UserDefaults? = .standard) {
        self.defaultValue = `default`
        self.key = key
        self.userDefaults = userDefaults
        self.pinger = PingersStorage.pinger(for: key)
    }

    public init<OptValue>(_ key: String, userDefaults: UserDefaults? = .standard) where Value == OptValue? {
        self.defaultValue = nil
        self.key = key
        self.userDefaults = userDefaults
        self.pinger = PingersStorage.pinger(for: key)
        subject.send(wrappedValue)
    }

    public init<Key: StorageKey>(_ key: Key.Type, userDefaults: UserDefaults? = .standard) where Key.Value == Value {
        self.defaultValue = key.defaultValue
        self.key = key.key
        self.userDefaults = userDefaults
        self.pinger = PingersStorage.pinger(for: key.key)
    }

    public init<OptValue, Key: StorageKey>(
        _ key: Key.Type,
        userDefaults: UserDefaults? = .standard
    ) where Value == OptValue?, Key.Value == Value {
        self.defaultValue = nil
        self.key = key.key
        self.userDefaults = userDefaults
        self.pinger = PingersStorage.pinger(for: key.key)
    }

    public var wrappedValue: Value {
        get {
            guard
                let data = userDefaults?.object(forKey: key) as? Data,
                let value = try? decoder.decode(Value.self, from: data) else {
                return defaultValue
            }

            return value
        }
        nonmutating set {
            let data = try? encoder.encode(newValue)
            pinger.ping()
            userDefaults?.set(data, forKey: key)
            subject.send(wrappedValue)
        }
    }

    public var projectedValue: Binding<Value> {
        Binding(
            get: { wrappedValue },
            set: { wrappedValue = $0 }
        )
    }

    var publisher: AnyPublisher<Value, Never> {
        subject.compactMap { $0 }.eraseToAnyPublisher()
    }
}

private class Pinger: ObservableObject {
    func ping() {
        objectWillChange.send()
    }
}

private enum PingersStorage {

    private static var storage: [String: Pinger] = [:]

    static func pinger(
        for key: String
    ) -> Pinger {
        if let pinger = storage[key] {
            return pinger
        }

        let pinger = Pinger()
        storage[key] = pinger
        return pinger
    }
}
