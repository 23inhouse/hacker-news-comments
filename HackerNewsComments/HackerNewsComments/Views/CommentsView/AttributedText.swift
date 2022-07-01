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
    @State private var isShowingNewsItem: Bool = false
    @State private var linkURL: URL? = nil

    var body: some View {
        ZStack {
            NavigationLink("", isActive: $isShowingNewsItem) {
                if let id = itemId(url: linkURL) {
                    let item = HackerNewsItem(id: id, title: "", commentCount: 0)
                    let commentsVM = CommentsVM(item: item)
                    CommentsView(commentsVM: commentsVM)
                }
            }

            InternalUITextView(text: text, dynamicHeight: $height, linkURL: $linkURL)
                .frame(minHeight: height)
        }
        .onChange(of: linkURL) { linkURL in
            guard let absoluteString = linkURL?.absoluteString else { return }
            if absoluteString.contains("news.ycombinator.com/item?id=") {
                guard itemId(url: linkURL) != nil else { return }
                isShowingNewsItem = true
            } else if let linkURL = linkURL {
                UIApplication.shared.open(linkURL)
            } else {
                isShowingNewsItem = false
            }
        }
    }

    private func itemId(url: URL?) -> Int? {
        guard let url = url else { return nil }

        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        guard let itemId = queryItems?.first(where: { $0.name == "id" })?.value else { return nil }
        return Int(itemId)
    }

    class ClickableUITextView: UITextView, UITextViewDelegate {
        @Binding var linkURL: URL?

        init(linkURL: Binding<URL?>) {
            self._linkURL = linkURL
            super.init(frame: .zero, textContainer: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            linkURL = URL
            return false
        }
    }

    struct InternalUITextView: UIViewRepresentable {
        var text: NSAttributedString
        @Binding var dynamicHeight: CGFloat
        @Binding var linkURL: URL?

        func makeUIView(context: Context) -> UITextView {
            let view = ClickableUITextView(linkURL: $linkURL)

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
