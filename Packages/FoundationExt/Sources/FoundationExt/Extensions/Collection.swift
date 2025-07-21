public extension Collection {

    var nilIfEmpty: Self? {
        if isEmpty { nil } else { self }
    }
}
