import Core
import StoreKit
import UIKitExt

@MainActor
enum FeedbackService {

    @Storage("feedback_was_asked", default: false)
    private static var feedbackWasAsked: Bool

    static func requestReview() {
        if feedbackWasAsked {
            if let url = URL(string: "https://apps.apple.com/app/id\(AppConstant.appstoreID)?action=write-review"),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        } else {
            feedbackWasAsked = true
            askRateUs()
        }
    }

    private static func askRateUs() {
        UIApplication.keyWindowScene.map { scene in
            AppStore.requestReview(in: scene)
        }
    }
}
