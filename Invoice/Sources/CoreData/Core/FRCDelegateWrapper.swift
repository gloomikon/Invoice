import CoreData

private var frcDelegates: [ObjectIdentifier: AnyObject] = [:]

enum FetchResultStream {

    static func make<T: NSFetchRequestResult>(
        for frc: NSFetchedResultsController<T>
    ) -> AsyncStream<Void> {
        AsyncStream { continuation in
            let delegate = FRCDelegateWrapper {
                continuation.yield()
            }

            frc.delegate = delegate
            let key = ObjectIdentifier(frc)
            frcDelegates[key] = delegate

            do {
                try frc.performFetch()
                continuation.yield()
            } catch {
                #if DEBUG
                print("FRC fetch failed:", error)
                #endif
            }

            continuation.onTermination = { _ in
                frc.delegate = nil
                frcDelegates.removeValue(forKey: key)
            }
        }
    }
}

private class FRCDelegateWrapper: NSObject, NSFetchedResultsControllerDelegate {
    private let onChange: () -> Void

    init(onChange: @escaping () -> Void) {
        self.onChange = onChange
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        onChange()
    }

    deinit {
        print("DEINIT")
    }
}
