import SwiftUIExt
import UIKitExt

struct CreateBusinessView: View {

    @ObservedObject var viewModel: CreateBusinessViewModel

    private var header: some View {
        Text("New Business")
            .font(.poppins(size: 22, weight: .semiBold))
            .frame(maxWidth: .infinity)
            .overlay(alignment: .leading) {
                Button {
                    viewModel.close()
                } label: {
                    Icon(systemName: "xmark")
                        .scaledToFit()
                        .frame(height: 16)
                        .font(.system(size: 14, weight: .medium))
                }
                .buttonStyle(.icon)
            }
            .foregroundStyle(.textPrimary)
    }

    private enum Focus: Hashable {
        case name
        case contactName
        case contactEmail
        case contactPhone
        case contactAddress
    }

    @FocusState private var focus: Focus?

    @State private var showNoNameError = false

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Business Name")
                .textCase(nil)
                .font(.poppins(size: 12, weight: .medium))
                .foregroundStyle(.textSecondary)

            TextField(
                "",
                text: $viewModel.name,
                prompt: Text(
                    String(localized: "Name")
                        .attributedString
                        .setForegroundColor(.textSecondary)
                )
            )
            .focused($focus, equals: .name)
            .textFieldStyle(DefaultTextFieldStyle(hasError: showNoNameError))
            .clipShape(.rect(cornerRadius: 12))
            .autocorrectionDisabled()
            .padding(.top, 12)

            Text("Business name is required")
                .font(.poppins(size: 12, weight: .medium))
                .foregroundStyle(.red)
                .opacity(showNoNameError ? 1 : 0)
                .animation(.easeInOut(duration: 0.2), value: showNoNameError)
                .padding(.top, 8)
        }
    }

    @State private var maxElementWidth: CGFloat = 0

    private enum TypingState {
        case initial
        case startedTyping
        case typing
        case finishedTyping
    }

    @State private var emailTypingState: TypingState = .initial
    @State private var wrongEmail = false

    @ViewBuilder
    private var signatureSection: some View {
        VStack {
            if let signature = viewModel.signature {
                Container {
                    Image(uiImage: signature)
                        .resizable()
                        .scaledToFill()
                }
                .background(.white)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.linkedIn, lineWidth: 2)
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.clearSignature()
                    } label: {
                        Icon(systemName: "trash")
                            .scaledToFit()
                            .frame(width: 16)
                            .padding(6)
                            .foregroundStyle(.red)
                            .background(
                                .red.opacity(0.2),
                                in: .rect(cornerRadius: 8)
                            )
                    }
                    .buttonStyle(.icon)
                    .padding(12)
                }
            } else {
                Button {
                    viewModel.openSignature()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .overlay {
                            VStack(spacing: 12) {
                                Text("Add the signature (optional)")
                                    .font(.poppins(size: 14))

                                Icon(systemName: "pencil.and.outline")
                                    .scaledToFit()
                                    .frame(width: 30)
                            }
                            .foregroundStyle(.textSecondary)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.textSecondary, style: .init(lineWidth: 2, dash: [5, 5]))
                        }
                        .frame(height: 200)
                }
                .buttonStyle(.icon)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.signature == nil)
    }

    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Business Contacts")
                .textCase(nil)
                .font(.poppins(size: 12, weight: .medium))
                .foregroundStyle(.textSecondary)

            VStack(spacing: 0) {

                TextField(
                    "",
                    text: $viewModel.contactName,
                    prompt: Text(
                        String(localized: "Optional")
                            .attributedString
                            .setForegroundColor(.textSecondary)
                    )
                )
                .focused($focus, equals: .contactName)
                .textFieldStyle(
                    ClearableTextFieldStyle(
                        description: "Name",
                        descriptionWidth: maxElementWidth,
                        text: $viewModel.contactName,
                        hasError: false
                    )
                )
                .contentShape(.rect)
                .onTapGesture {
                    focus = .contactName
                }

                TextField(
                    "",
                    text: $viewModel.contactEmail,
                    prompt: Text(
                        String(localized: "Optional")
                            .attributedString
                            .setForegroundColor(.textSecondary)
                    )
                )
                .focused($focus, equals: .contactEmail)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(
                    ClearableTextFieldStyle(
                        description: "E-mail",
                        descriptionWidth: maxElementWidth,
                        text: $viewModel.contactEmail,
                        hasError: wrongEmail
                    )
                )
                .contentShape(.rect)
                .onTapGesture {
                    focus = .contactEmail
                }

                TextField(
                    "",
                    text: $viewModel.contactPhone,
                    prompt: Text(
                        String(localized: "Optional")
                            .attributedString
                            .setForegroundColor(.textSecondary)
                    )
                )
                .focused($focus, equals: .contactPhone)
                .keyboardType(.phonePad)
                .textFieldStyle(
                    ClearableTextFieldStyle(
                        description: "Phone",
                        descriptionWidth: maxElementWidth,
                        text: $viewModel.contactPhone,
                        hasError: false
                    )
                )
                .contentShape(.rect)
                .onTapGesture {
                    focus = .contactPhone
                }

                HStack(alignment: .top, spacing: .zero) {
                    Text("Address")
                        .frame(width: maxElementWidth + 12, alignment: .leading)
                        .padding(.top, 12)
                        .contentShape(.rect)
                        .onTapGesture {
                            focus = .contactAddress
                        }

                    TextField(
                        "",
                        text: $viewModel.contactAddress,
                        prompt: Text(
                            String(localized: "Optional")
                                .attributedString
                                .setForegroundColor(.textSecondary)
                        ),
                        axis: .vertical
                    )
                    .focused($focus, equals: .contactAddress)
                    .textFieldStyle(DefaultTextFieldStyle(hasError: false))
                    .frame(minHeight: 60, alignment: .top)
                    .onTapGesture {
                        focus = .contactAddress
                    }
                }
                .padding(.leading, 12)
            }
            .background(.white, in: .rect(cornerRadius: 12))
            .autocorrectionDisabled()
        }
        .overlay {
            ZStack {
                Text("Name")
                    .hidden()
                    .onWidthChange { width in
                        if width > maxElementWidth {
                            maxElementWidth = width
                        }
                    }

                Text("E-mail")
                    .hidden()
                    .onWidthChange { width in
                        if width > maxElementWidth {
                            maxElementWidth = width
                        }
                    }

                Text("Phone")
                    .hidden()
                    .onWidthChange { width in
                        if width > maxElementWidth {
                            maxElementWidth = width
                        }
                    }

                Text("Address")
                    .hidden()
                    .onWidthChange { width in
                        if width > maxElementWidth {
                            maxElementWidth = width
                        }
                    }
            }
            .allowsHitTesting(false)
        }
        .font(.poppins(size: 14, weight: .medium))
        .foregroundStyle(.textPrimary)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: .zero) {
                header
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                Rectangle()
                    .fill(.neutral300)
                    .frame(height: 1)
                ScrollView {
                    VStack(spacing: 12) {
                        nameSection
                        contactsSection
                        signatureSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            }
            .onTapGesture {
                focus = nil
            }
            .onChange(of: viewModel.name) { _ in
                showNoNameError = false
            }
            .onChange(of: focus) { newValue in
                if newValue == .contactEmail {
                    emailTypingState = .startedTyping
                } else {
                    emailTypingState = .finishedTyping
                    if viewModel.contactEmail.isEmpty {
                        // do nothing
                    } else {
                        if Email(viewModel.contactEmail) == nil {
                            wrongEmail = true
                        }
                    }
                }
            }
            .onChange(of: viewModel.contactEmail) { _ in
                if emailTypingState == .startedTyping {
                    emailTypingState = .typing
                }
                wrongEmail = false
            }
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: .zero) {
                    LinearGradient(
                        colors: [.clear, .backgroundPrimary],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 14)
                    Button("Save") {
                        if viewModel.name.isEmpty {
                            showNoNameError = true
                        } else {
                            viewModel.save()
                        }
                    }
                    .buttonStyle(.primary)
                    .padding(.bottom, 24)
                    .padding(.top, 6)
                    .padding(.horizontal, 16)
                    .background(.backgroundPrimary)
                }
            }
            .background(.backgroundPrimary)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        focus = nil
                    } label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                    }
                }
            }
        }
    }
}

private struct DefaultTextFieldStyle: TextFieldStyle {

    let hasError: Bool

    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(.white)
            .font(.poppins(size: 14))
            .foregroundColor(.textPrimary)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(hasError ? .red : .clear, lineWidth: 1)
                    .animation(.easeInOut(duration: 0.2), value: hasError)
            }
    }
}

private struct ClearableTextFieldStyle: TextFieldStyle {

    let description: LocalizedStringKey
    let descriptionWidth: CGFloat
    @Binding var text: String
    let hasError: Bool

    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {
        HStack(spacing: 12) {
            Text(description)
                .font(.poppins(size: 14, weight: .medium))
                .foregroundStyle(.textPrimary)
                .frame(width: descriptionWidth, alignment: .leading)

            configuration
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.poppins(size: 14))
                .foregroundStyle(hasError ? .red : .textPrimary)
                .padding(.leading, 12)

            Button {
                text = ""
            } label: {
                Circle()
                    .fill(.neutral500)
                    .frame(width: 16, height: 16)
                    .overlay {
                        Icon(systemName: "xmark")
                            .scaledToFit()
                            .bold()
                            .padding(5)
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.icon)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
        }
        .padding(12)
        .background(.white)
        .font(.poppins(size: 14))
        .foregroundColor(.textPrimary)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(.backgroundPrimary)
                .frame(height: 1)
        }
        .animation(.easeInOut(duration: 0.2), value: hasError)
    }
}
