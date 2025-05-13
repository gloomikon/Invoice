struct NetworkError: Error {

    let description: String
    let code: Int

    init(_ description: String, code: Int) {
        self.description = description
        self.code = code
    }
}
