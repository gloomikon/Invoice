import Combine

public extension Publisher {

    func nonNil<T>() -> Publishers.CompactMap<Self, T> where Output == T? {
        compactMap { $0 }
    }
}
