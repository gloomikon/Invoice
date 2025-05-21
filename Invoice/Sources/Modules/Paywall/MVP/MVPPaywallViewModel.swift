import Combine

class MVPPaywallViewModel: BasePaywallViewModel {

    override func bind() {
        super.bind()
        buttonTitle = String(localized: "Continue")
    }
}
