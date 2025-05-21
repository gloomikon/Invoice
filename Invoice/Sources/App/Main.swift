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
        }

        UIApplicationMain(
            CommandLine.argc,
            CommandLine.unsafeArgv,
            nil,
            NSStringFromClass(AppDelegate.self)
        )
    }
}
