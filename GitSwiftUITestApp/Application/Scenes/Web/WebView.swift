import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
  
  typealias UIViewType = WKWebView

  var url: URL
  
  func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
    WKWebView()
  }
  
  func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) {
    let request = URLRequest(url: url)
    uiView.load(request)
  }
}
