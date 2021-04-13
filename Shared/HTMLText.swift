//
//  HTMLText.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 08.04.2021.
//

import SwiftUI

class HTMLTextCache {

    static let shared = HTMLTextCache()
    private init() {}

    private var attributedStrings = [String: NSAttributedString]()

    func generateAttributedString(for textFileName: String) {

        DispatchQueue.global(qos: .default).async {

            if let file = Bundle.main.url(forResource: textFileName, withExtension: "html"),
               let data = try? Data(contentsOf: file),
               let html = String(data: data, encoding: .utf8) {

                let data = Data(html.utf8)
                if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {

                    DispatchQueue.main.async {
                        self.attributedStrings[textFileName] = attributedString
                    }//: DispatchQueue.main.async
                }//: NSAttributedString generation
            }//: get
        }//: qos
    }

    func attributedString(for textFileName: String) -> NSAttributedString? {
        return attributedStrings[textFileName]
    }

}

struct HTMLText: UIViewRepresentable {

    let attributedString: NSAttributedString

    init?(textFileName: String) {
        if let string = HTMLTextCache.shared.attributedString(for: textFileName) {
            self.attributedString = string
        } else {
            return nil
        }
    }

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0

        label.setContentHuggingPriority(.required, for: .horizontal) // << here !!
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.attributedText = attributedString

        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {

    }
}

struct HTMLText_Previews: PreviewProvider {
    static var previews: some View {
        HTMLText(textFileName: "SampleContent.txt")
    }
}
