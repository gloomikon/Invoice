import CombineExt
import DebugPanel

class RemoteConfigService {

    private let provider: RemoteConfigProvider

    init(provider: RemoteConfigProvider) {
        self.provider = provider
    }

    func start() async throws {
        try await provider.start()
    }

    private var storage: [ObjectIdentifier: CurrentValueSubject<RemoteValue, Never>] = [:]
    private var bag = CancelBag()

    func value<T: RemoteValue>(for key: RemoteKey) -> T {
        let storageKey = ObjectIdentifier(T.self)

        // If value is cached - return it
        if let publisher = storage[storageKey] as? CurrentValueSubject<T, Never> {
            return publisher.value
        }

        // Try to get value from debug panel
        var remoteValue: T? = debugValue(for: key)

        // It it is absent, get real value
        if remoteValue == nil {
            remoteValue = provider.value(for: key)
        }

        if remoteValue == nil {
            // track or something
        }

        if let experiment = remoteValue as? ExperimentalGroupTrackable {
            RemoteConfigEvent.experiment(
                name: experiment.experimentalGroupName,
                value: experiment.experimentalGroupValue
            )
            .send()
        }

        let finalized: T = remoteValue ?? .default

        storage[storageKey] = CurrentValueSubject(finalized)

        observeChanges(for: key)

        return finalized
    }

    func publisher<T: RemoteValue>(for key: RemoteKey) -> AnyPublisher<T, Never> {
        let storageKey = ObjectIdentifier(T.self)
        if let publisher = storage[storageKey] as? CurrentValueSubject<T, Never> {
            return publisher.eraseToAnyPublisher()
        }

        let _: T = value(for: key)
        // swiftlint:disable:next force_unwrapping
        return storage[storageKey]!
            .compactMap { $0 as? T }
            .eraseToAnyPublisher()
    }

    func values(for keys: [RemoteKey]) {
        keys.forEach { key in
            value(for: key, type: key.valueType)
        }
    }

    @discardableResult
    private func value<T: RemoteValue>(for key: RemoteKey, type: T.Type) -> T {
        value(for: key)
    }

    private func updateValue<T: BoolRemoteValue>(
        for key: RemoteKey,
        type: T.Type,
        with value: DebugPanel.BoolRemoteValue
    ) {
        let storageKey = ObjectIdentifier(T.self)
        guard let publisher = storage[storageKey] else {
            return
        }

        let remoteValue: T = switch value {
        case .default:
            provider.value(for: key) ?? .default
        case .selected(let value):
            T(value)
        }

        publisher.send(remoteValue)
    }

    private func updateValue<T: StringRemoteValue>(
        for key: RemoteKey,
        type: T.Type,
        with value: DebugPanel.StringRemoteValue
    ) {
        let storageKey = ObjectIdentifier(T.self)
        guard let publisher = storage[storageKey] else {
            return
        }

        let remoteValue: T = switch value {
        case .default:
            provider.value(for: key) ?? .default
        case .selected(let value):
            T(rawValue: value) ?? .default
        }

        publisher.send(remoteValue)
    }

    private func debugValue<T: RemoteValue>(for key: RemoteKey) -> T? {
        if let type = key.valueType as? any BoolRemoteValue.Type {
            switch DebugPanelStorage.shared.boolRemoteValue(for: key.key) {
            case .default:
                nil
            case .selected(let value):
                type.init(value) as? T
            }
        } else if let type = key.valueType as? any StringRemoteValue.Type {
            switch DebugPanelStorage.shared.stringRemoteValue(for: key.key) {
            case .default:
                nil
            case .selected(let value):
                type.init(rawValue: value) as? T
            }
        } else {
            nil
        }
    }

    private func observeChanges(for key: RemoteKey) {
        if let type = key.valueType as? any BoolRemoteValue.Type {
            DebugPanelStorage.shared.didChangeBoolRemotePublisher(for: key.key)
                .sink { [unowned self] value in
                    updateValue(for: key, type: type, with: value)
                }
                .store(in: &bag)
        } else if let type = key.valueType as? any StringRemoteValue.Type {
            DebugPanelStorage.shared.didChangeStringRemotePublisher(for: key.key)
                .sink { [unowned self] value in
                    updateValue(for: key, type: type, with: value)
                }
                .store(in: &bag)
        }
    }
}
