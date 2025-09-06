//
//  WebView.swift
//  Scrap Wale
//
//  Created by WEBbrella Infotech on 17/07/25.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers

struct WebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.allowsInlineMediaPlayback = true

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    // 🔑 Reload page when url changes
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url != url {
            uiView.load(URLRequest(url: url))
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, UIDocumentPickerDelegate {
        private var completionHandler: (([URL]?) -> Void)?

        // Keep all navigation inside WebView
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated,
               let _ = navigationAction.request.url {
                decisionHandler(.allow) // always open inside WebView
            } else {
                decisionHandler(.allow)
            }
        }

        // Handle <input type="file"> for file upload (iOS 18.4+ only)
        @available(iOS 18.4, *)
        func webView(_ webView: WKWebView,
                     runOpenPanelWith parameters: WKOpenPanelParameters,
                     initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping ([URL]?) -> Void) {
            self.completionHandler = completionHandler

            let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data])
            picker.delegate = self
            picker.allowsMultipleSelection = false

            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first?.rootViewController {
                rootVC.present(picker, animated: true)
            }
        }

        // Document Picker Delegate
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completionHandler?(urls)
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completionHandler?(nil)
        }
    }
}
