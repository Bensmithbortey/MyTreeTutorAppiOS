//
//  HTMLText.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 08.04.2021.
//

import SwiftUI
import WebKit

struct HTMLText: UIViewRepresentable {

    private let fileURL: URL
    private let folderURL: URL

    init?(textFileName: String) {
        if let file = Bundle.main.url(forResource: textFileName, withExtension: "html") {
            fileURL = file
            
            var folder = file
            folder.deleteLastPathComponent()
            folderURL = folder
        } else {
            return nil
        }
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> WKWebView {
        let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 30, height: 50))

        webView.setContentHuggingPriority(.required, for: .horizontal) // << here !!
        webView.setContentHuggingPriority(.required, for: .vertical)
        webView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        webView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        webView.loadFileURL(fileURL, allowingReadAccessTo: folderURL)

        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
}

struct HTMLText_Previews: PreviewProvider {
    static var previews: some View {
        HTMLText(textFileName: "SampleContent.txt")
    }
}
