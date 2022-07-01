//
//  AttributedText.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 27/6/2022.
//

import SwiftUI


struct AttributedTextView: View {
    var text: NSAttributedString
    @State private var height: CGFloat = .zero

    var body: some View {
        InternalUITextView(text: text, dynamicHeight: $height)
            .frame(minHeight: height)
    }

    class ClickableUITextView: UITextView, UITextViewDelegate {
        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            print(URL)

            return false
        }
    }

    struct InternalUITextView: UIViewRepresentable {
        var text: NSAttributedString
        @Binding var dynamicHeight: CGFloat

        func makeUIView(context: Context) -> UITextView {
            let view = ClickableUITextView()

            view.dataDetectorTypes = .link
            view.isEditable = false
            view.isSelectable = true
            view.isScrollEnabled = false
            view.delegate = view
            view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            view.textContainer.lineFragmentPadding = 0;

            return view
        }

        func updateUIView(_ uiView: UITextView, context: Context) {
            uiView.attributedText = text

            DispatchQueue.main.async {
                dynamicHeight = uiView.sizeThatFits(CGSize(width: uiView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
            }
        }
    }
}

struct AttributedText_Previews: PreviewProvider {
    static let text = HackerNewsCommentFormatter.call(
        """
        <p>The kicker:<p>&quot;the reduction function&quot; it won&#x27;t work
        <p>The kicker:<a href="foobar.com">link body</a>
        <p>> here is commented code<p>Here is not a comment
        <p>content with<p>a new paragraph
        """
    )

    static var previews: some View {
        AttributedTextView(text: text)
            .frame(maxWidth: 300)
            .previewLayout(.sizeThatFits)
    }
}
