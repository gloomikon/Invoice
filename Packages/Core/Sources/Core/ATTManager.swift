import AppTrackingTransparency

public enum ATTManager {

    public static func requestAuthorization() async {
        let currentStatus = ATTrackingManager.trackingAuthorizationStatus

        guard currentStatus == .notDetermined else {
            return
        }

        let status = await ATTrackingManager.requestTrackingAuthorization()
        CoreEvent.permissionAsked(granted: status == .authorized)
            .send()
    }
}
