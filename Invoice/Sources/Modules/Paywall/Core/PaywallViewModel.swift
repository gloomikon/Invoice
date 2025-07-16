import Combine

@MainActor protocol PaywallViewModel: ObservableObject {

    var buttonTitle: String { get }
    var crossVisible: Bool { get }
    var isLoading: Bool { get set }

    var alert: PaywallAlert? { get set }

    func close()
    func buy()
    func restore()
    func openTermsOfUse()
    func openPrivacyPolicy()
}
