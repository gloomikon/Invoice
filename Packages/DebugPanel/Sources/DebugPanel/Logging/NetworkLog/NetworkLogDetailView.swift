import Highlight
import SwiftUI

struct NetworkLogDetailView: View {

    @ObservedObject var logger: NetworkLogger
    let id: UUID

    private var log: NetworkLog {
        logger.logs.first { $0.id == id }!
    }

    private var requestHeader: some View {
        HStack {
            Image(systemName: "tray.and.arrow.up.fill")
            Text("Request")
        }
    }

    private var responseHeader: some View {
        HStack {
            Image(systemName: "tray.and.arrow.down.fill")
            Text("Response")
        }
    }

    @ViewBuilder
    private var requestContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(log.requestMethod)
                .bold()
                .font(.title2)
            Text(log.requestURL)
        }

        if let requestHeaders = log.requestHeaders {
            VStack(alignment: .leading, spacing: 8) {
                Text("Headers")
                    .bold()
                    .font(.title2)

                let headers =
                """
                {
                \(requestHeaders.map { key, value in "    \"\(key)\" : \"\(value)\""}.joined(separator: ",\n"))
                }
                """

                Text(AttributedString(JsonSyntaxHighlightProvider.shared.highlight(headers, as: .json)))
            }
        }

        if let httpBody = log.httpBody {
            VStack(alignment: .leading, spacing: 8) {
                Text("Body")
                    .bold()
                    .font(.title2)

                if let body = httpBody.prettyJSON {
                    let string = JsonSyntaxHighlightProvider.shared.highlight(body, as: .json)
                    Text(AttributedString(string))
                } else {
                    Text("data is not json")
                }
            }
        }
    }

    @ViewBuilder
    private var responseContent: some View {
        if let statusCode = log.responseStatusCode {
            Text("\(statusCode)")
                .bold()
                .font(.title2)
        }

        if let responseHeaders = log.responseHeaders {
            VStack(alignment: .leading, spacing: 8) {
                Text("Headers")
                    .bold()
                    .font(.title2)

                let headers =
                """
                {
                \(responseHeaders.map { key, value in "    \"\(key)\" : \"\(value)\""}.joined(separator: ",\n"))
                }
                """

                Text(AttributedString(JsonSyntaxHighlightProvider.shared.highlight(headers, as: .json)))
            }
        }

        if let httpBody = log.data {
            VStack(alignment: .leading, spacing: 8) {
                Text("Body")
                    .bold()
                    .font(.title2)

                if let body = httpBody.prettyJSON {
                    let string = JsonSyntaxHighlightProvider.shared.highlight(body, as: .json)
                    Text(AttributedString(string))
                } else {
                    Text(String(decoding: httpBody, as: UTF8.self))
                }
            }
        }

        if let error = log.error {
            VStack(alignment: .leading, spacing: 8) {
                Text("Error")
                    .bold()
                    .font(.title2)
                
                Text(error)
            }
        }
    }

    @State private var requestExpanded = true
    @State private var responseExpanded = true

    var body: some View {
        List {
            if #available(iOS 17, *) {
                Section(isExpanded: $requestExpanded) {
                    requestContent
                } header: {
                    requestHeader
                }
                .headerProminence(.increased)
            } else {
                Section {
                    requestContent
                } header: {
                    requestHeader
                }
            }

            if #available(iOS 17, *) {
                Section(isExpanded: $responseExpanded) {
                    responseContent
                } header: {
                    responseHeader
                }
                .headerProminence(.increased)
            } else {
                Section {
                    responseContent
                } header: {
                    responseHeader
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    copyToClipboard(log.debugDescription)
                } label: {
                    Image(systemName: "doc.on.doc")
                }
            }
        }
    }
}
