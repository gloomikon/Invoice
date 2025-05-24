public protocol Event { }

public extension Event {

    func send() {
        EventProcessorsIncubator.shared.process(self)
    }
}

public protocol EventProcessor: AnyObject {
    associatedtype EventType: Event
    func process(_ event: EventType)
}

extension EventProcessor {
    // swiftlint:disable:next identifier_name
    func _process(_ event: Event) {
        if let event = event as? EventType {
            process(event)
        }
    }

    public func start() {
        EventProcessorsIncubator.shared.addProcessor(self)
    }

    public func stop() {
        EventProcessorsIncubator.shared.removeProcessor(self)
    }
}

public protocol CompositeEventProcessor: AnyObject {
    func process<E: Event>(_ event: E)
}

public extension CompositeEventProcessor {
    func start() {
        EventProcessorsIncubator.shared.addProcessor(self)
    }

    func stop() {
        EventProcessorsIncubator.shared.removeProcessor(self)
    }
}

private class EventProcessorsIncubator {

    static let shared = EventProcessorsIncubator()

    private init() { }

    private var processors: [ObjectIdentifier: [any EventProcessor]] = [:]
    private var compositeProcessors: [ObjectIdentifier: CompositeEventProcessor] = [:]

    func process(_ event: Event) {
        let key = key(for: event)
        let processors = processors[key, default: []]
        processors.forEach { processor in
            processor._process(event)
        }
        compositeProcessors.values.forEach { processor in
            processor.process(event)
        }
    }

    func addProcessor<Processor: EventProcessor>(_ processor: Processor) {
        let key = ObjectIdentifier(Processor.EventType.self)
        processors[key, default: []].append(processor)
    }

    func addProcessor<Processor: CompositeEventProcessor>(_ processor: Processor) {
        let key = key(for: processor)
        compositeProcessors[key] = processor
    }

    func removeProcessor<Processor: EventProcessor>(_ processor: Processor) {
        let key = ObjectIdentifier(Processor.EventType.self)
        processors[key]?.removeAll {
            ObjectIdentifier($0) == ObjectIdentifier(processor)
        }
        if processors[key]?.isEmpty == true {
            processors.removeValue(forKey: key)
        }
    }

    func removeProcessor<Processor: CompositeEventProcessor>(_ processor: Processor) {
        let key = key(for: processor)
        compositeProcessors[key] = nil
    }

    private func key(for event: Event) -> ObjectIdentifier {
        ObjectIdentifier(type(of: event))
    }

    private func key<Processor: CompositeEventProcessor>(
        for processor: Processor
    ) -> ObjectIdentifier {
        ObjectIdentifier(processor)
    }
}
