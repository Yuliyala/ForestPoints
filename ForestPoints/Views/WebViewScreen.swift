import SwiftUI
import WebKit

struct WebViewScreenView: View {
    @Environment(\.dismiss) var dismiss
    let url: URL
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(.back)
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            
            WebView(url: url)
                .ignoresSafeArea(edges: .bottom)
        }
        .bgSetup()
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

#Preview {
    WebViewScreenView(url: URL(string: "https://www.google.com")!)
}

