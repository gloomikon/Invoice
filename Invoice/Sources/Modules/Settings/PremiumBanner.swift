import SwiftUI

struct PremiumBanner: View {

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                Image(.crown)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 27)
                    .frame(width: 52, height: 52)
                    .background(
                        .backgroundPrimary,
                        in: .rect(cornerRadius: 10)
                    )
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.border, lineWidth: 1)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Become Premium Member")
                        .font(.poppins(size: 14, weight: .semiBold))
                    Text("Unlimited invoices. Advanced features. No limits")
                        .font(.poppins(size: 12))
                }
                .foregroundStyle(.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text("Try for free")
                .font(.poppins(size: 16, weight: .semiBold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(.linkedIn, in: .capsule)
        }
        .padding(16)
        .background(.white, in: .rect(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.border, lineWidth: 1)
        }
    }
}
