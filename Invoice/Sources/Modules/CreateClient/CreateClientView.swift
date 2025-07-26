import SwiftUI
import UIKitExt

struct CreateClientView: View {

    @ObservedObject var viewModel: CreateClientViewModel

    private var header: some View {
        Text("New Client")
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
        case email
        case phone
        case address
    }

    @FocusState private var focus: Focus?

    @State private var showNoNameError = false

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("Name")
                .textCase(nil)
                .font(.poppins(size: 12, weight: .medium))
                .foregroundStyle(.textSecondary)

            TextField(
                "",
                text: $viewModel.name,
                prompt: Text(
                    String(localized: "Client's Name")
                        .attributedString
                        .setForegroundColor(.textSecondary)
                )
            )
            .focused($focus, equals: .name)
            .textFieldStyle(DefaultTextFieldStyle(hasError: showNoNameError))
            .clipShape(.rect(cornerRadius: 12))
            .autocorrectionDisabled()
            .padding(.top, 12)

            Text("Client's name is required")
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

    private var contactsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Contacts")
                .textCase(nil)
                .font(.poppins(size: 12, weight: .medium))
                .foregroundStyle(.textSecondary)

            VStack(spacing: 0) {

                TextField(
                    "",
                    text: $viewModel.email,
                    prompt: Text(
                        String(localized: "Optional")
                            .attributedString
                            .setForegroundColor(.textSecondary)
                    )
                )
                .focused($focus, equals: .email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(
                    ClearableTextFieldStyle(
                        description: "E-mail",
                        descriptionWidth: maxElementWidth,
                        text: $viewModel.email,
                        hasError: wrongEmail
                    )
                )
                .contentShape(.rect)
                .onTapGesture {
                    focus = .email
                }

                TextField(
                    "",
                    text: $viewModel.phone,
                    prompt: Text(
                        String(localized: "Optional")
                            .attributedString
                            .setForegroundColor(.textSecondary)
                    )
                )
                .focused($focus, equals: .phone)
                .keyboardType(.phonePad)
                .textFieldStyle(
                    ClearableTextFieldStyle(
                        description: "Phone",
                        descriptionWidth: maxElementWidth,
                        text: $viewModel.phone,
                        hasError: false
                    )
                )
                .contentShape(.rect)
                .onTapGesture {
                    focus = .phone
                }

                HStack(alignment: .top, spacing: .zero) {
                    Text("Address")
                        .frame(width: maxElementWidth + 12, alignment: .leading)
                        .padding(.top, 12)
                        .contentShape(.rect)
                        .onTapGesture {
                            focus = .address
                        }

                    TextField(
                        "",
                        text: $viewModel.address,
                        prompt: Text(
                            String(localized: "Optional")
                                .attributedString
                                .setForegroundColor(.textSecondary)
                        ),
                        axis: .vertical
                    )
                    .focused($focus, equals: .address)
                    .textFieldStyle(DefaultTextFieldStyle(hasError: false))
                    .frame(minHeight: 60, alignment: .top)
                    .onTapGesture {
                        focus = .address
                    }
                }
                .padding(.leading, 12)
            }
            .background(.white, in: .rect(cornerRadius: 12))
            .autocorrectionDisabled()
        }
        .overlay {
            ZStack {
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

    private var importClient: some View {
        Button {
            pickContact { contact in
                viewModel.importedContact(contact)
            }
        } label: {
            HStack(spacing: 8) {
                Icon(.contactBook)
                    .scaledToFit()
                    .frame(width: 18)
                Text("Import from contacts")
            }
            .frame(height: 40)
            .foregroundStyle(.textPrimary)
            .font(.poppins(size: 14, weight: .medium))
            .padding(.horizontal, 12)
            .overlay {
                Capsule()
                    .stroke(.neutral300, lineWidth: 1)
            }
        }
        .buttonStyle(.icon)
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
                        importClient
                        nameSection
                        contactsSection
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
                if newValue == .email {
                    emailTypingState = .startedTyping
                } else {
                    emailTypingState = .finishedTyping
                    if viewModel.email.isEmpty {
                        // do nothing
                    } else {
                        if Email(viewModel.email) == nil {
                            wrongEmail = true
                        }
                    }
                }
            }
            .onChange(of: viewModel.email) { _ in
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
