import SwiftUI

public typealias CancelBag = Set<AnyCancellable>

public extension Set<AnyCancellable> {

    mutating func clear() {
        removeAll()
    }
}
