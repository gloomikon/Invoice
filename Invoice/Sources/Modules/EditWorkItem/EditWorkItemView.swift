import Core
import SwiftUIExt
import UIKitExt

struct EditWorkItemView: View {

    @ObservedObject var viewModel: EditWorkItemViewModel

    @Storage(CurrencyStorageKey.self) private var currency

    private var header: some View {
        Text("Edit item")
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
        case description
        case price
        case quantity
        case discount
    }

    @FocusState private var focus: Focus?

    @State private var showNoNameError = false

    private var nameSection: some View {
        VStack(spacing: .zero) {
            TextField(
                "",
                text: $viewModel.name,
                prompt: Text("Name")
                    .foregroundColor(showNoNameError ? .red : .textSecondary)
            )
            .focused($focus, equals: .name)
            .textFieldStyle(DefaultTextFieldStyle())

            Rectangle()
                .fill(.backgroundPrimary)
                .frame(height: 1)

            TextField(
                "",
                text: $viewModel.description,
                prompt: Text("Details (e.g. task scope, tools used)")
                    .foregroundColor(.textSecondary),
                axis: .vertical
            )
            .focused($focus, equals: .description)
            .textFieldStyle(DefaultTextFieldStyle())
            .frame(minHeight: 60, alignment: .top)
            .onTapGesture {
                focus = .description
            }
        }
        .padding(.horizontal, 12)
        .background(.white, in: .rect(cornerRadius: 16))
    }

    private var price: some View {
        HStack(spacing: .zero) {
            Text(currency.abbreviation)
                .font(.poppins(size: 14))
                .foregroundStyle(.textPrimary)
            TextField(
                "",
                value: $viewModel.price,
                format: .number,
                prompt: Text("0")
                    .foregroundColor(.textSecondary)
            )
            .focused($focus, equals: .price)
            .keyboardType(.decimalPad)
            .textFieldStyle(DefaultTextFieldStyle())
        }
    }

    private var quantity: some View {
        TextField(
            "",
            value: $viewModel.quantity,
            format: .number,
            prompt: Text("1")
                .foregroundColor(.textSecondary)
        )
        .focused($focus, equals: .price)
        .keyboardType(.numberPad)
        .textFieldStyle(DefaultTextFieldStyle())
    }

    @State private var maxElementWidth: CGFloat = .zero

    private var unitType: some View {
        ZStack {
            Text("Optional")
                .hidden()
                .onWidthChange { width in
                    if width > maxElementWidth {
                        maxElementWidth = width
                    }
                }
            ForEach(WorkItem.UnitType.allCases, id: \.self) { type in
                Text(type.title)
                    .hidden()
                    .onWidthChange { width in
                        if width > maxElementWidth {
                            maxElementWidth = width
                        }
                    }
            }
            Menu {
                Picker(
                    "",
                    selection: $viewModel.unitType
                ) {
                    Text("None")
                        .tag(nil as WorkItem.UnitType?)

                    ForEach(WorkItem.UnitType.allCases, id: \.self) { type in
                        Text(type.title)
                            .tag(Optional(type))
                    }
                }
                .labelsHidden()
            } label: {
                Text(viewModel.unitType?.title ?? "Optional")
                    .foregroundStyle(viewModel.unitType == nil ? .textSecondary : .textPrimary)
                    .animation(.easeInOut(duration: 0.1), value: viewModel.unitType)
                    .frame(width: maxElementWidth)
                    .padding(.leading, 12)
            }
        }
        .font(.poppins(size: 14))
        .colorScheme(.light)
    }

    @ViewBuilder
    private var infoSection: some View {
        VStack(spacing: 4) {

            HStack(spacing: .zero) {
                Text("Price")
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Quantity")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 12)

                Text("Type")
                    .frame(width: maxElementWidth, alignment: .leading)
                    .padding(.leading, 12)
            }
            .font(.poppins(size: 12, weight: .medium))
            .foregroundStyle(.textSecondary)
            .padding(.horizontal, 12)

            HStack(spacing: .zero) {
                price
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(.backgroundPrimary)
                            .frame(width: 1)
                    }
                quantity
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(.backgroundPrimary)
                            .frame(width: 1)
                    }
                unitType
            }
            .padding(.horizontal, 12)
            .background(.white, in: .rect(cornerRadius: 16))

            totalPriceDescription
        }
    }

    @ViewBuilder
    private var totalPriceDescription: some View {
        let quantity = viewModel.quantity ?? 1
        let price = viewModel.price ?? 0
        let total = viewModel.totalPrice
        let discountText: String = if
            viewModel.hasDiscount,
            let discount = viewModel.discount {
            switch viewModel.discountType {
            case .percentage:
                String(localized: " − \(String(format: "%.2f", discount))% off")
            case .fixed:
                String(localized: " − \(String(format: "%.2f", discount)) \(currency.abbreviation) off")
            }
        } else {
            ""
        }

        let totalString = String(format: "%.2f", total)
        let currency = currency.abbreviation
        let description = "(\(quantity) × \(String(format: "%.2f", price)) \(currency)\(discountText))"

        Text(verbatim: "\(totalString) \(currency) \(description)")
            .font(.poppins(size: 12, weight: .medium))
            .foregroundStyle(.textSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var discountSectionHeader: some View {
        HStack(spacing: .zero) {
            Text("Discount")
            Spacer()
            let totalDiscount = String(format: "%.2f", viewModel.totalDiscount)
            Text(verbatim: "\(totalDiscount) \(currency.abbreviation)")
        }
        .font(.poppins(size: 12, weight: .medium))
        .foregroundStyle(.textSecondary)
    }

    private var discountSectionInput: some View {
        HStack(spacing: .zero) {
            TextField(
                "",
                value: $viewModel.discount,
                format: .number,
                prompt: Text("0")
                    .foregroundColor(.textSecondary)
            )
            .focused($focus, equals: .discount)
            .keyboardType(.decimalPad)
            .textFieldStyle(DefaultTextFieldStyle())
            .onChange(of: viewModel.discount) { _ in
                viewModel.hasDiscount = true
            }

            Toggle("", isOn: $viewModel.hasDiscount)
                .tint(.linkedIn)
                .labelsHidden()
                .padding(.trailing, 12)
        }
    }

    @ViewBuilder
    private var discountSectionPicker: some View {
        if viewModel.hasDiscount {
            Picker("", selection: $viewModel.discountType) {
                Text(verbatim: "%")
                    .tag(EditWorkItemViewModel.Discount.percentage)
                Text(verbatim: currency.abbreviation)
                    .tag(EditWorkItemViewModel.Discount.fixed)
            }
            .pickerStyle(.segmented)
            .colorScheme(.light)
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
    }

    private var discountSection: some View {
        VStack(spacing: 4) {
            discountSectionHeader
            VStack(spacing: 4) {
                discountSectionInput
                discountSectionPicker
            }
            .background(.white, in: .rect(cornerRadius: 16))
        }
    }

    private var taxSection: some View {
        Toggle("Taxable?", isOn: $viewModel.taxable)
            .tint(.linkedIn)
            .font(.poppins(size: 14, weight: .medium))
            .foregroundStyle(.textPrimary)
            .padding(.horizontal, 12)
    }

    private var deleteItem: some View {
        Button {
            viewModel.delete()
        } label: {
            HStack(spacing: 8) {
                Icon(systemName: "trash")
                    .scaledToFit()
                    .frame(width: 12)
                Text("Delete item")
            }
            .padding(8)
            .foregroundStyle(.red)
            .font(.poppins(size: 14, weight: .medium))
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
                    VStack(spacing: 24) {
                        nameSection
                        infoSection
                        discountSection
                        taxSection
                        deleteItem
                    }
                    .animation(.easeInOut(duration: 0.2), value: viewModel.hasDiscount)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                }
                .scrollIndicators(.hidden)
            }
            .onChange(of: viewModel.name) { _ in
                showNoNameError = false
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
            .background {
                Color.backgroundPrimary
                    .onTapGesture {
                        focus = nil
                    }
                    .ignoresSafeArea()
            }
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

    // swiftlint:disable:next identifier_name
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .padding(12)
            .background(.white)
            .font(.poppins(size: 14))
            .foregroundColor(.textPrimary)
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
