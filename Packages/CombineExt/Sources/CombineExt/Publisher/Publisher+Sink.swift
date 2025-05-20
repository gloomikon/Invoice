import Combine

public extension Publisher {
    func sink() -> AnyCancellable {
        sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}

public extension Publisher where Self.Output == Void, Self.Failure == Never {
    func sink(receiveValue: @escaping (() -> Void)) -> AnyCancellable {
        sink { _ in
            receiveValue()
        }
    }
}

public extension Publisher where Self.Output == Void {
    func sink(
        receiveCompletion: @escaping ((Subscribers.Completion<Self.Failure>) -> Void),
        receiveValue: @escaping (() -> Void)
    ) -> AnyCancellable {
        sink {
            receiveCompletion($0)
        } receiveValue: { _ in
            receiveValue()
        }
    }
}

public extension Publisher {
    func sink(
        onFinished: (() -> Void)? = nil,
        onError: ((Failure) -> Void)? = nil,
        onValue: ((Output) -> Void)? = nil,
        onAny: (() -> Void)? = nil,
        onAnyCompletion: (() -> Void)? = nil
    ) -> AnyCancellable {
        sink { completion in
            switch completion {
            case .finished:
                onFinished?()
            case .failure(let error):
                onError?(error)
            }
            onAny?()
            onAnyCompletion?()
        } receiveValue: { value in
            onAny?()
            onValue?(value)
        }
    }
}
