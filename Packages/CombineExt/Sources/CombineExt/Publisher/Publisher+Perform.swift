import Combine

public extension Publisher {

    func perform(action: @escaping (Self.Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: action)
    }
}
