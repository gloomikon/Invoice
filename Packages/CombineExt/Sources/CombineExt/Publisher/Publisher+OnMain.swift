
import Combine
import Foundation

public extension Publisher {
    func onMain() -> Publishers.ReceiveOn<Self, DispatchQueue> {
        receive(on: DispatchQueue.main)
    }
}
