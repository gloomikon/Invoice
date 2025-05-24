import EventKit

enum RemoteConfigEvent: Event {

    case experiment(name: String, value: String)
}

class RemoteConfigEventProcessor: EventProcessor {

    func process(_ event: RemoteConfigEvent) {
        switch event {
        case let .experiment(name, value):
            set(name, with: value)
        }
    }
}
