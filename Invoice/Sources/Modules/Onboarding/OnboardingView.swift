import SwiftUIExt

struct OnboardingView: View {

    private let titles: [LocalizedStringKey] = [
        "Create invoices in\nseconds",
        "Never worry about\nfollow-ups",
        "Stay organized\neffortlessly"
    ]

    private let subtitles: [LocalizedStringKey] = [
        "Just fill in the details —\nWe’ll handle the rest",
        "We watch the clock, so you\ndon’t have to",
        "Track payments and keep\nall invoices in one place"
    ]

    @ObservedObject var viewModel: OnboardingViewModel

    private var footer: some View {
        VStack(spacing: .zero) {
            Text(titles[viewModel.page])
                .font(.poppins(size: 28, weight: .semiBold))
                .foregroundStyle(.textPrimary)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.25), value: viewModel.page)

            Text(subtitles[viewModel.page])
                .font(.poppins(size: 16))
                .foregroundStyle(.textSecondary)
                .padding(.top, 8)
                .animation(.easeInOut(duration: 0.25), value: viewModel.page)

            Pager(currentPage: viewModel.page, totalPages: 3)
                .padding(.top, 24)

            Button("Continue") {
                viewModel.openNextPage()
            }
            .buttonStyle(.primary)
            .padding(.top, 24)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .padding(.bottom, 55)
        .padding(.top, 34)
        .background(.white, in: .rect(cornerRadius: 16))
        .background {
            Color.white
                .padding(.top, 16)
                .ignoresSafeArea(edges: .bottom)
        }
    }

    var body: some View {
        VStack(spacing: .zero) {
            LinearGradient(
                colors: [
                    Color(hex: "#6E9FFF"),
                    Color(hex: "#0766C1")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .overlay {
                GridShape(spacing: 30)
                    .stroke(
                        RadialGradient(
                            colors: [.white, .white.opacity(0.2)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 150
                        ),
                        lineWidth: 1
                    )
                    .padding(.leading, -5)
            }
            .ignoresSafeArea(edges: .top)
            .overlay {
                VStack {
                    switch viewModel.page {
                    case 0:
                        Header1()
                            .transition(.opacity.combined(with: .blur()))
                    case 1:
                        Header2()
                            .transition(.opacity.combined(with: .blur()))
                    case 2:
                        Header3()
                            .transition(.opacity.combined(with: .blur()))

                    default:
                        EmptyView()
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: viewModel.page)
            }
            footer
                .padding(.top, -16)
        }
    }
}

private struct Pager: View {

    let currentPage: Int
    let totalPages: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<totalPages, id: \.self) { idx in
                RoundedRectangle(cornerRadius: 4)
                    .fill(currentPage == idx ? .neutral500 : .neutral300)
                    .frame(width: currentPage == idx ? 20 : 8, height: 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}

private struct Header1: View {

    @State private var animate = false

    var body: some View {
        ZStack {

            Image(.iPhoneOnboarding1)
                .resizable()
                .aspectRatio(832 / 1188, contentMode: .fit)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .padding(.top, 16)

            WidthReader { width in
                Image(.invoiceOnboarding1)
                    .resizable()
                    .aspectRatio(759 / 590, contentMode: .fit)
                    .padding(16)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
                    .shadow(radius: 8)
                    .frame(width: width * 0.7)
                    .scaleEffect(animate ? 1 : 0, anchor: .topLeading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing, 16)
                    .padding(.bottom, 25)
                    .colorScheme(.light)
            }
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.8)) {
                animate = true
            }
        }
    }
}

private struct Header2: View {

    @State private var animate = false
    @State private var iPhoneFrame: CGRect = .zero

    var body: some View {

        let proportion = iPhoneFrame.width / 1341

        Image(.iPhoneOnboarding2)
            .resizable()
            .aspectRatio(1323 / 1907, contentMode: .fit)
            .onFrameChange($iPhoneFrame)
            .overlay(alignment: .top) {
                let width = 3132 / 2.8 * proportion
                let paddingTop = 240 * proportion
                Image(.iPhonePush2)
                    .resizable()
                    .aspectRatio(3132 / 656, contentMode: .fit)
                    .frame(width: width)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 80 * proportion))
                    .padding(.top, animate ? paddingTop : -150)
                    .colorScheme(.dark)
            }
            .overlay(alignment: .top) {
                let width = 376 * proportion
                let paddingTop = 100 * proportion
                Image(.iPhoneNotch2)
                    .resizable()
                    .aspectRatio(376 / 111, contentMode: .fit)
                    .frame(width: width)
                    .padding(.top, paddingTop)
            }
            .overlay(alignment: .trailing) {
                Text("1")
                    .font(.system(size: 54 * proportion))
                    .frame(width: 75 * proportion, height: 75 * proportion)
                    .foregroundStyle(.white)
                    .background(.red, in: .circle)
                    .scaleEffect(animate ? 1 : 0, anchor: .center)
                    .opacity(animate ? 1 : 0)
                    .padding(.top, 480 * proportion)
                    .padding(.trailing, 130 * proportion)
            }
            .clipped()
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    withAnimation(.bouncy(duration: 0.5)) {
                        animate = true
                    }
                }
            }
    }
}

private struct Header3: View {

    @State private var iPhoneFrame: CGRect = .zero

    @State private var animate1 = false
    @State private var animate2 = false
    @State private var animate3 = false

    var body: some View {
        let proportion = iPhoneFrame.width / 949

        let height = 198 * proportion
        let width = 798 * proportion
        let radius = 30 * proportion
        let lineWidth = 3 * proportion
        let spacing = 40 * proportion
        let offset = 60 * proportion

        Image(.iPhoneOnboarding3)
            .resizable()
            .aspectRatio(949 / 1328, contentMode: .fit)
            .onFrameChange($iPhoneFrame)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
            .padding(.top, 16)
            .overlay(alignment: .bottomLeading) {
                Image(.invoiceItemOnboarding31)
                    .resizable()
                    .aspectRatio(798 / 198, contentMode: .fit)
                    .frame(width: width, height: height)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: radius))
                    .background(.white.opacity(0.3), in: .rect(cornerRadius: radius))
                    .overlay {
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(.white, lineWidth: lineWidth)
                    }
                    .padding(.bottom, 24 + spacing + height + spacing + height + spacing)
                    .offset(x: animate1 ? iPhoneFrame.minX - offset : -width - 5)
            }
            .overlay(alignment: .bottomTrailing) {
                Image(.invoiceItemOnboarding32)
                    .resizable()
                    .aspectRatio(798 / 198, contentMode: .fit)
                    .frame(width: width, height: height)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: radius))
                    .background(.white.opacity(0.3), in: .rect(cornerRadius: radius))
                    .overlay {
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(.white, lineWidth: lineWidth)
                    }
                    .padding(.bottom, 24 + spacing + height + spacing)
                    .offset(x: animate2 ? -iPhoneFrame.minX + offset : width + 5)
            }
            .overlay(alignment: .bottomLeading) {
                Image(.invoiceItemOnboarding33)
                    .resizable()
                    .aspectRatio(798 / 198, contentMode: .fit)
                    .frame(width: width, height: height)
                    .background(.ultraThinMaterial, in: .rect(cornerRadius: radius))
                    .background(.white.opacity(0.3), in: .rect(cornerRadius: radius))
                    .overlay {
                        RoundedRectangle(cornerRadius: radius)
                            .stroke(.white, lineWidth: lineWidth)
                    }
                    .padding(.bottom, 24 + spacing)
                    .offset(x: animate3 ? iPhoneFrame.minX - offset : -width - 5)
            }
            .colorScheme(.light)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { _ in
                    withAnimation(.bouncy(duration: 0.5)) {
                        animate1 = true
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
                    withAnimation(.bouncy(duration: 0.5)) {
                        animate2 = true
                    }
                }
                Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { _ in
                    withAnimation(.bouncy(duration: 0.5)) {
                        animate3 = true
                    }
                }
            }
    }
}
