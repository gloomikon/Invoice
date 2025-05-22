protocol AnalyticsProperty: CustomStringConvertible {
    var analyticsName: String { get }
}

extension AnalyticsProperty {
    var description: String {
        analyticsName
    }
}

extension AnalyticsProperty where Self: RawRepresentable<String> {

    var analyticsName: String {
        rawValue
    }
}
