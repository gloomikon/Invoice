import SwiftUI

struct SimpleLogsView: View {

    @ObservedObject var logger: SimpleLogger

    @State private var searchableString = ""

    private var logs: [SimpleLog] {
        if searchableString.isEmpty {
            logger.logs.reversed()
        } else {
            logger.logs.reversed().filter { log in
                log.text.localizedStandardContains(searchableString)
            }
        }
    }

    var body: some View {
        List(logs) { log in
            HStack(alignment: .bottom) {
                Text(
                    AttributedString(stringLiteral: log.text)
                        .setBackgroundColor(
                            .systemPurple.withAlphaComponent(0.5),
                            to: searchableString,
                            caseInsensitive: true
                        )
                )
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)

                Text(log.date.formatted(date: .omitted, time: .standard))
                    .foregroundStyle(.secondary)
                    .font(.footnote)
            }
        }
        .navigationTitle("Logs")
        .searchable(text: $searchableString, placement: .navigationBarDrawer(displayMode: .always))
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
        let content = logs
            .map {
                $0.date.formatted(date: .omitted, time: .standard) +
                "\n" +
                $0.text
            }
            .joined(separator: "\n\n***********************\n\n")

        share(content: content, toFile: "logs_\(UUID().uuidString).txt")
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
