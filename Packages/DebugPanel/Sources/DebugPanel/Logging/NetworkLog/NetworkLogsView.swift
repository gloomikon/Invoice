import SwiftUI

struct NetworkLogsView: View {

    @ObservedObject var logger: NetworkLogger
    @EnvironmentObject private var viewModel: DebugPanelViewModel

    @State private var searchableString = ""

    private var logs: [NetworkLog] {
        if searchableString.isEmpty {
            logger.logs.reversed()
        } else {
            logger.logs.reversed().filter {
                $0.requestURL.localizedStandardContains(searchableString)
            }
        }
    }

    @ViewBuilder private func view(for log: NetworkLog) -> some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .foregroundStyle(.blue)
                        .frame(height: 12)

                    Text(log.requestDate.formatted(date: .omitted, time: .standard))
                        .font(.footnote)
                        .foregroundStyle(.secondary)

                    if let responseDate = log.responseDate {
                        let hasError = log.error != nil
                        Image(systemName: "arrow.down")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(hasError ? .red : .green)
                            .frame(height: 12)

                        Text(responseDate.formatted(date: .omitted, time: .standard))
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    } else {
                        Image(systemName: "arrow.down")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.orange)
                            .frame(height: 12)
                    }

                    if let duration = log.duration {
                        Text(" - \(duration)s")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    if let statusCode = log.responseStatusCode {
                        let color: Color = switch statusCode {
                        case (200..<300):
                                .green
                        case (300..<400):
                                .orange
                        case (400..<600):
                                .red
                        default:
                                .secondary
                        }
                        Text("\(statusCode)")
                            .font(.footnote)
                            .foregroundStyle(color)
                    }
                }
                Text(
                    AttributedString(stringLiteral: log.requestURL)
                        .setBackgroundColor(
                            .systemPurple.withAlphaComponent(0.5),
                            to: searchableString,
                            caseInsensitive: true
                        )
                )
                .font(.system(size: 16))
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Image(systemName: "chevron.right")
                .renderingMode(.template)
                .foregroundStyle(.secondary)
        }
        .contentShape(.rect)
    }

    var body: some View {
        List(logs) { log in
            view(for: log)
                .onTapGesture {
                    viewModel.openScreen(.networkLog(logger: logger, id: log.id))
                }
        }
        .navigationTitle("Network Logs")
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
            .map(\.debugDescription)
            .joined(separator: "\n\n***********************\n\n")

        share(content: content, toFile: "network_logs_\(UUID().uuidString).txt")
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

