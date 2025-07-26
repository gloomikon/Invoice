import ContactsUI
import SwiftUI
import UIKitExt

struct Contact: Identifiable {

    let id: String
    let name: String
    let email: String?
    let phone: String?
    let address: String?

    init(contact: CNContact) {
        self.id = contact.identifier

        let fullName = [contact.givenName, contact.familyName]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        self.name = if fullName.isEmpty {
            contact.organizationName.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            fullName
        }

        self.email = contact.emailAddresses.first?.value as String?
        self.phone = contact.phoneNumbers.first?.value.stringValue

        if let postal = contact.postalAddresses.first?.value {
            let parts = [postal.street, postal.city, postal.state, postal.postalCode, postal.country]
            self.address = parts.filter { !$0.isEmpty }.joined(separator: ", ")
        } else {
            self.address = nil
        }
    }
}

extension View {

    func pickContact(_ onSelect: @escaping (Contact) -> Void) {
        ContactPicker.shared.onSelect = onSelect
        ContactPicker.shared.present()
    }

    func pickContacts(_ onSelect: @escaping ([Contact]) -> Void) {
        ContactsPicker.shared.onSelect = onSelect
        ContactsPicker.shared.present()
    }
}

private class ContactPicker: NSObject, CNContactPickerDelegate {

    static let shared = ContactPicker()

    private override init() {

    }

    var onSelect: ((Contact) -> Void)?

    init(onSelect: @escaping (Contact) -> Void) {
        self.onSelect = onSelect
    }

    func present() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.predicateForSelectionOfContact = NSPredicate(value: true)
        picker.predicateForSelectionOfProperty = NSPredicate(value: false)

        UIApplication.keyWindow?.rootViewController?.topPresentedViewController
            .present(picker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        onSelect?(Contact(contact: contact))
    }
}

private class ContactsPicker: NSObject, CNContactPickerDelegate {

    static let shared = ContactsPicker()

    private override init() {

    }

    var onSelect: (([Contact]) -> Void)?

    init(onSelect: @escaping ([Contact]) -> Void) {
        self.onSelect = onSelect
    }

    func present() {
        let picker = CNContactPickerViewController()
        picker.delegate = self
        picker.predicateForSelectionOfContact = NSPredicate(value: false)
        picker.predicateForSelectionOfProperty = NSPredicate(value: false)

        UIApplication.keyWindow?.rootViewController?.topPresentedViewController
            .present(picker, animated: true)
    }

    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        onSelect?(contacts.map { Contact(contact: $0) })
    }
}
