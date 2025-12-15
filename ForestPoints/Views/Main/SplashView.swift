import SwiftUI

struct SplashView: View {
    @StateObject var viewModel = LaunchViewModel()

    var body: some View {
        if viewModel.shouldNavigate {
            MainView()
        } else {
            ZStack {
                Image(.appBg)
                    .resizable()
                    .ignoresSafeArea()
                Image(.splashLogo)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal, 20)
                    .scaleEffect(viewModel.isAnimating ? 1.05 : 0.95)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true),
                        value: viewModel.isAnimating
                    )
            }
            .onAppear {
                viewModel.start()
            }
        }
    }
}

class LaunchViewModel: ObservableObject {
    @Published var shouldNavigate = false
    @Published var isAnimating = false

    func start() {
        isAnimating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.shouldNavigate = true
            }
        }
    }
}

