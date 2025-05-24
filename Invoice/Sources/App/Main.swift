import Depin
import UIKit

@main
enum Main {

    @Space(\.dependenciesAssembler)
    private static var assembler

    static func main() {

        assembler.apply {
            AppAssembly()
            PaywallAssembly()
            AnalyticsAssembly()
        }

        startProcessors()

        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            nil,
            NSStringFromClass(AppDelegate.self)
        )
    }

    private static func startProcessors() {
        @Injected var compositor: AnalyticsClientCompositor
        compositor.start()

        @Injected var purchaseManager: PurchaseManager
        purchaseManager.start()

        PaywallEventProcessor().start()
        AdjustEventProcessor().start()
    }
}
