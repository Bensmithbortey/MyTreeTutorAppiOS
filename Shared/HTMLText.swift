//
//  HTMLText.swift
//  MyTreeTutorApp
//
//  Created by Benjamin-Smith Bortey on 08.04.2021.
//

import SwiftUI

struct HTMLText: UIViewRepresentable {

   let html: String

    init(_ html: String) {
        self.html = html
    }

    init?(textFileName: String) {
        if let file = Bundle.main.url(forResource: textFileName, withExtension: "html"),
           let data = try? Data(contentsOf: file),
           let html = String(data: data, encoding: .utf8) {
            self.html = html
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

        DispatchQueue.main.async {
            let data = Data(html.utf8)
            if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                label.attributedText = attributedString
            }
        }

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
