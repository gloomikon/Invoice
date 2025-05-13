// swiftlint:disable all

import Foundation
import Security

/// Class Key Constant
private let Class = String(kSecClass)

/// Attribute Key Constants
private let AttributeAccessible = String(kSecAttrAccessible)

private let AttributeService = String(kSecAttrService)
private let AttributeGeneric = String(kSecAttrGeneric)
private let AttributeAccount = String(kSecAttrAccount)
private let AttributeAccessGroup = String(kSecAttrAccessGroup)
private let AttributeSynchronizable = String(kSecAttrSynchronizable)
private let AttributeDescription = String(kSecAttrDescription)
private let AttributeLabel = String(kSecAttrLabel)

/// Return Type Key Constants
private let ReturnData = String(kSecReturnData)
private let ReturnPersistentRef = String(kSecReturnPersistentRef)
private let ValuePersistentRef = String(kSecValuePersistentRef)
private let ReturnAttributes = String(kSecReturnAttributes)

/// Value Type Key Constants
private let ValueData = String(kSecValueData)

/// Search Constants
private let MatchLimit = String(kSecMatchLimit)
private let MatchLimitOne = String(kSecMatchLimitOne)
private let MatchLimitAll = String(kSecMatchLimitAll)

public class KeychainManager {

    let service: String
    let accessGroup: String?
    let synchronizable: Bool
    let accessibility: Accessibility

    public init(settings: KeychainSettings) {
        self.service = settings.service
        self.accessGroup = settings.accessGroup
        self.synchronizable = settings.synchronizable
        self.accessibility = settings.accessibility
    }

    private func prepareDictionary(key: String? = nil, ignoringSynchronizable: Bool) -> [String: Any] {
        var dictionary: [String: Any] = [:]

        dictionary[Class] = String(kSecClassGenericPassword)

        dictionary[AttributeService] = service

        dictionary[AttributeAccessible] = accessibility.stringValue

        if ignoringSynchronizable {
            dictionary[AttributeSynchronizable] = kSecAttrSynchronizableAny
        } else {
            dictionary[AttributeSynchronizable] = synchronizable ? kCFBooleanTrue : kCFBooleanFalse
        }

        if let accessGroup {
            dictionary[AttributeAccessGroup] = accessGroup
        }

        if let key = key {
            let encodedKey: Data? = key.data(using: .utf8)
            dictionary[AttributeGeneric] = encodedKey
            dictionary[AttributeAccount] = key
        }

        return dictionary
    }


    @discardableResult
    public func insert(forKey key: String, with data: Data?) -> Bool {
        var dictionary = prepareDictionary(key: key, ignoringSynchronizable: false)

        dictionary[ValueData] = data

        dictionary[ReturnPersistentRef] = kCFBooleanTrue

        let status = SecItemAdd(dictionary as CFDictionary, nil)
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
            return update(forKey: key, with: data)
        } else {
            return false
        }
    }

    public func string(from persistentReference: Data) -> String? {
        var returnValue: String?
        var dictionary: [String: Any] = [:]
        dictionary[Class] = String(kSecClassGenericPassword)
        dictionary[ReturnData] = kCFBooleanTrue
        dictionary[ValuePersistentRef] = persistentReference

        var result: CFTypeRef? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        if let passwordData = result as? Data, status == errSecSuccess {
            returnValue = String(data: passwordData, encoding: .utf8)
        }
        return returnValue
    }

    public func insertReference(containing data: String, called name: String, previouslyReferencedBy oldReference: Data? = nil) -> Data? {

        var dictionary = prepareDictionary(ignoringSynchronizable: false)
        dictionary[AttributeAccount] = name
        dictionary[ValueData] = data.data(using: .utf8) as Any
        dictionary[ReturnPersistentRef] = kCFBooleanTrue

        var returnValue: OSStatus
        var result: CFTypeRef? = nil
        returnValue = SecItemAdd(dictionary as CFDictionary, &result)
        if returnValue != errSecSuccess || result == nil {
            debugPrint("Unable to add data to keychain: \(returnValue)")
            return nil
        }

        if let oldReference = oldReference {
            removeReference(called: oldReference)
        }
        return result as? Data
    }

    public func dataRef(forKey key: String) -> Data? {
        var dictionary = prepareDictionary(key: key, ignoringSynchronizable: false)

        dictionary[MatchLimit] = MatchLimitOne

        dictionary[ReturnPersistentRef] = kCFBooleanTrue

        var result: CFTypeRef? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        if status != errSecSuccess {
            return nil
        }
        return result as? Data
    }

    public func data(forKey key: String) -> Data? {
        var dictionary = prepareDictionary(key: key, ignoringSynchronizable: false)

        dictionary[MatchLimit] = MatchLimitOne

        dictionary[ReturnData] = kCFBooleanTrue

        var result: AnyObject?
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        return status == noErr ? result as? Data : nil
    }

    public func string(forKey key: String) -> String? {
        guard let data = data(forKey: key) else {
            return nil
        }
        return String(data: data, encoding: .utf8) as String?
    }

    public func bool(forKey key: String) -> Bool? {
        guard let data = data(forKey: key) else {
            return nil
        }
        guard let byte = data.first else {
            return nil
        }
        return byte == 1
    }

    public func update(forKey key: String, with data: Data?) -> Bool {
        let dictionary = prepareDictionary(key: key, ignoringSynchronizable: false)
        var dictUpdate: [String: Any] = [:]
        dictUpdate[ValueData] = data

        let status = SecItemUpdate(dictionary as CFDictionary, dictUpdate as CFDictionary)
        guard status == errSecSuccess else {
            return oneMoreTryToUpdate(forKey: key, with: data)
        }

        return true
    }

    @discardableResult
    public func remove(forKey key: String) -> Bool {
        var dictionary: [String: Any] = [:]

        dictionary[Class] = String(kSecClassGenericPassword)
        dictionary[AttributeService] = service
        if let accessGroup = self.accessGroup {
            dictionary[AttributeAccessGroup] = accessGroup
        }
        dictionary[AttributeSynchronizable] = kSecAttrSynchronizableAny
        dictionary[AttributeAccount] = key

        let status = SecItemDelete(dictionary as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return false
        }

        return true
    }

    @discardableResult
    public func removeAllKeys(_ securityClass: SecurityClass) -> Bool {
        var dictionary: [String: Any] = [:]

        dictionary[Class] = securityClass.rawValue
        dictionary[AttributeService] = service
        if let accessGroup = self.accessGroup {
            dictionary[AttributeAccessGroup] = accessGroup
        }

        let status = SecItemDelete(dictionary as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return false
        }

        return true
    }

    @discardableResult
    public func removeAllKeys() -> Bool {
        removeAllKeys(.genericPassword)
    }

    public func removeAllKeys(except list: [String]) {
        do {
            let allKeys = try obtainAllKeys()
            let filteredKeys = allKeys.filter { !list.contains($0) }
            filteredKeys.forEach { remove(forKey: $0) }
        } catch let error {
            debugPrint("Failed to remove keys. Reason: \(error.localizedDescription)")
        }
    }

    public func wipe() {
        SecurityClass.allCases.forEach {
            removeAllKeys($0)
        }
    }

   public func removeReference(called persistentReference: Data) {
        var dictionary: [String: Any] = [:]

        dictionary[ValuePersistentRef] = persistentReference

        let status = SecItemDelete(dictionary as CFDictionary)
        if status != errSecSuccess {
            debugPrint("Unable to remove reference from keychain: \(status)")
        }
    }

    public func verifyReference(called persistentReference: Data) -> Bool {
        var dictionary: [String: Any] = [:]

        dictionary[Class] = String(kSecClassGenericPassword)
        dictionary[ValuePersistentRef] = persistentReference

        var result: CFTypeRef? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)

        return status != errSecItemNotFound
    }

    public subscript(key: String) -> Data? {
        get {
            return data(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                remove(forKey: key)
                return
            }

            insert(forKey: key, with: newValue)
        }
    }

    public subscript(key: String) -> String? {
        get {
            return string(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                remove(forKey: key)
                return
            }

            let data = newValue.data(using:.utf8)

            insert(forKey: key, with: data)
        }
    }

    public subscript(key: String) -> Bool? {
        get {
            return bool(forKey: key)
        }
        set {
            guard let newValue = newValue else {
                remove(forKey: key)
                return
            }

            let bytes: [UInt8] = newValue ? [1] : [0]
            let data = Data(bytes)

            insert(forKey: key, with: data)
        }
    }
}

private extension KeychainManager {

    private func obtainAllKeys() throws -> [String] {
        var dictionary = prepareDictionary(ignoringSynchronizable: true)
        dictionary[ReturnAttributes] = kCFBooleanTrue
        dictionary[MatchLimit] = MatchLimitAll

        var result: CFTypeRef? = nil
        let status = SecItemCopyMatching(dictionary as CFDictionary, &result)
        guard status == errSecSuccess else {
            throw KeychainError.unexpected
        }

        guard let results = result as? [[AnyHashable: Any]] else {
            throw KeychainError.emptyResults
        }

        return results.compactMap {
            guard let accountData = $0[AttributeAccount] as? Data else { return nil }
            return String(data: accountData, encoding: .utf8)
        }
    }

    private func oneMoreTryToUpdate(forKey key: String, with data: Data?) -> Bool {
        if remove(forKey: key) && insert(forKey: key, with: data) {
            return true
        }

        wipe()
        return false
    }
}

// swiftlint:enable all
