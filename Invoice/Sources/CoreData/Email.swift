import Foundation

struct Email: Codable, Equatable {
    let email: String

    init?(_ email: String) {
        guard Email.isValid(email) else { return nil }
        self.email = email
    }

    private static func isValid(_ email: String) -> Bool {
        let regex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return NSPredicate(format: "SELF MATCHES[c] %@", regex).evaluate(with: email)
    }
}
