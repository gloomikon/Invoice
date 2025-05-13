import Combine
import Foundation

public class DebugPanelStorage {

    public static let shared = DebugPanelStorage()
    private let defaults = UserDefaults(suiteName: "debug_panel")
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private let didChangeBoolRemoteValueSubject = PassthroughSubject<(String, BoolRemoteValue), Never>()
    private let didChangeStringRemoteValueSubject = PassthroughSubject<(String, StringRemoteValue), Never>()

    private init() { }

    public func didChangeBoolRemotePublisher(for key: String) -> AnyPublisher<BoolRemoteValue, Never> {
        didChangeBoolRemoteValueSubject.filter { remoteValueKey, _ in
            remoteValueKey == key
        }
        .map { _, value in value }
        .eraseToAnyPublisher()
    }

    public func didChangeStringRemotePublisher(for key: String) -> AnyPublisher<StringRemoteValue, Never> {
        didChangeStringRemoteValueSubject.filter { remoteValueKey, _ in
            remoteValueKey == key
        }
        .map { _, value in value }
        .eraseToAnyPublisher()
    }

    public func boolRemoteValue(for key: String) -> BoolRemoteValue {
        guard let data = defaults?.data(forKey: key) else {
            return .default
        }

        guard let remoteValue = try? decoder.decode(BoolRemoteValue.self, from: data) else {
            return .default
        }

        return remoteValue
    }

    public func stringRemoteValue(for key: String) -> StringRemoteValue {
        guard let data = defaults?.data(forKey: key) else {
            return .default
        }

        guard let remoteValue = try? decoder.decode(StringRemoteValue.self, from: data) else {
            return .default
        }

        return remoteValue
    }

    func setRemoteValue(_ value: BoolRemoteValue, for key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults?.setValue(data, forKey: key)
        didChangeBoolRemoteValueSubject.send((key, value))
    }

    func setRemoteValue(_ value: StringRemoteValue, for key: String) {
        guard let data = try? encoder.encode(value) else { return }
        defaults?.setValue(data, forKey: key)
        didChangeStringRemoteValueSubject.send((key, value))
    }
}
