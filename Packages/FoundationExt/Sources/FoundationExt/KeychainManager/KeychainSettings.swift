import Foundation

public struct KeychainSettings {

    let service: String
    let accessGroup: String
    let synchronizable: Bool
    let accessibility: Accessibility

    public init(
        service: String,
        accessGroup: String,
        synchronizable: Bool,
        accessibility: Accessibility
    ) {
        self.service = service
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
        self.accessibility = accessibility
    }
}
