import Depin

class AnalyticsAssembly: Assembly {

    func assemble(container: Container) {

        container.registerSynchronized(AmplitudeClient.self) { r in
            let appStorage = r ~> AppStorage.self
            return AmplitudeClient(
                apiKey: AppConstant.amplitudeAPIKey,
                deviceID: appStorage.deviceUDID
            )
        }
        .inObjectScope(.container)

        container.registerSynchronized(AdjustAnalyticsClient.self) { r in
            let appStorage = r ~> AppStorage.self
            return AdjustAnalyticsClient(
                deviceID: appStorage.deviceUDID,
                appToken: AppConstant.adjustAppToken
            )
        }

        container.registerSynchronized(AnalyticsClientCompositor.self) { r in
            AnalyticsClientCompositor(clients: [
                r ~> AmplitudeClient.self,
                r ~> AdjustAnalyticsClient.self
            ])
        }
        .inObjectScope(.container)
    }
}
