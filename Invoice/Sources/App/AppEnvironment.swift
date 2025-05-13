enum AppEnvironment {

    case debug
    case production

    static var current: Self {
        #if DEBUG
        .debug
        #else
        .production
        #endif
    }
}
