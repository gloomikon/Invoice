import SwiftUI

struct SignatureView: View {

    @ObservedObject var viewModel: SignatureViewModel

    @State private var clearTrigger = false
    @State private var generateImageTrigger = false
    @State private var hasSignature = false

    private var header: some View {
        Button {
            viewModel.close()
        } label: {
            Icon(systemName: "xmark")
                .scaledToFit()
                .frame(height: 16)
                .font(.system(size: 14, weight: .medium))
        }
        .buttonStyle(.icon)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(.textPrimary)
    }

    var body: some View {
        VStack(spacing: .zero) {
            header
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

            VStack(spacing: 24) {
                Text("Sign below")
                    .font(.poppins(size: 27, weight: .semiBold))
                    .foregroundStyle(.textPrimary)

                SignatureDrawingView(
                    clearTrigger: $clearTrigger,
                    generateImageTrigger: $generateImageTrigger,
                    hasSignature: $hasSignature,
                    generateImageHandler: { signatureImage in
                        viewModel.createSignatureTapped(signature: signatureImage)
                    }
                )
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.linkedIn, lineWidth: 2)
                )
                .padding(.horizontal, 16)
            }
            .frame(maxHeight: .infinity)
        }
        .background(.backgroundPrimary)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 16) {

                Button("Clean") {
                    clearTrigger = true
                }
                .buttonStyle(.secondary)
                .padding(.top, 24)
                .padding(.horizontal, 16)

                Button("Create") {
                    generateImageTrigger = true
                }
                .buttonStyle(.primary)
                .disabled(!hasSignature)
                .padding(.bottom, 24)
                .padding(.horizontal, 16)
            }
        }
    }
}
