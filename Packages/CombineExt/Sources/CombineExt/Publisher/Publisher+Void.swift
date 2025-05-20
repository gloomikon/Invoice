import Combine

public extension Publisher {
    func void() -> Publishers.Map<Self, Void> {
        map { _ in }
    }
}
