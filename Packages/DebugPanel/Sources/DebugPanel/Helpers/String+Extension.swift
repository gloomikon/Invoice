extension String {

    func starts(with string: String) -> Bool {
        lowercased().hasPrefix(string.lowercased())
    }
}
