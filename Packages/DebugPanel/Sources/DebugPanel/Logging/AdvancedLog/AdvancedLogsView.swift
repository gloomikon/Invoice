import SwiftUI

struct AdvancedLogsView: View {

    @ObservedObject var logger: AdvancedLogger

    var body: some View {
        List(logger.logs) { log in
            HStack(spacing: 16) {
                switch log.severity {
                case .none:
                    Icon(
                        icon: Image(
                            systemName: ""
                        ),
                        tintColor: .primary,
                        backgroundColor: .primary.opacity(0.1)
                    )
                case .info:
                    Icon(
                        icon: Image(
                            systemName: "info.circle"
                        ),
                        tintColor: .primary,
                        backgroundColor: .primary.opacity(0.1)
                    )
                case .warning:
                    Icon(
                        icon: Image(systemName: "exclamationmark.triangle"),
                        tintColor: .yellow,
                        backgroundColor: .yellow.opacity(0.15)
                    )
                case .error:
                    Icon(
                        icon: Image(systemName: "xmark"),
                        tintColor: .red,
                        backgroundColor: .red.opacity(0.15)
                    )
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(log.issuer)
                        Spacer()
                        Text(log.date.formatted(date: .omitted, time: .standard))
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)

                    Text(log.message)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    export()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }

            ToolbarItem {
                Button {
                    clear()
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }

    private func export() {
        let logs = logger.logs.reversed()
        let content = logs
            .map(\.debugDescription)
            .joined(separator: "\n\n***********************\n\n")

        share(content: content, toFile: "advanced_logs_\(UUID().uuidString).txt")
    }

    private func clear() {
        logger.clear()
    }

    private func share(content: String, toFile file: String) {

        do {
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent(file)
            try content.write(to: fileURL, atomically: true, encoding: .utf8)

            let activityViewController = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)

            guard let viewController = UIApplication.keyWindow?.rootViewController?.topViewController else {
                return
            }
            viewController.present(activityViewController, animated: true, completion: nil)
        } catch { }
    }
}
