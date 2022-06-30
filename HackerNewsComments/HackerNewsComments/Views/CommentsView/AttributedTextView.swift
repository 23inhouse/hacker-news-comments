//
//  AttributedTextView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 27/6/2022.
//

import SwiftUI

@available(iOS 15.0, *)
struct AttributedTextView: View {
    let text: String
    @State private var paragraphs: [AttributedString] = []
    @State private var isShowingNewsItem: Bool = false
    @State private var newsItemID: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(paragraphs, id: \.self) { paragraph in
                ZStack {
                    NavigationLink("", isActive: $isShowingNewsItem) {
                        if let id = newsItemID {
                            let item = HackerNewsItem(id: id, title: "", commentCount: 0)
                            let commentsVM = CommentsVM(item: item)
                            CommentsView(commentsVM: commentsVM)
                        }
                    }

                    Text(paragraph)
                        .environment(\.openURL, OpenURLAction { linkURL in
                            guard let id = itemId(url: linkURL) else { return .systemAction }

                            newsItemID = id
                            isShowingNewsItem = true
                            return .discarded
                        })
                }
            }
        }
        .onAppear {
            paragraphs = HTML2AttributedStringParser(string: text).texts
        }
    }

    private func itemId(url: URL?) -> Int? {
        guard let url = url else { return nil }

        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        guard let itemId = queryItems?.first(where: { $0.name == "id" })?.value else { return nil }
        return Int(itemId)
    }
}

@available(iOS 15.0, *)
struct AttributedTextView_Previews: PreviewProvider {
    static let text =
        """
        <b>Some bold text</b>
        <p><i>Some italic text</i>
        <p>The kicker:<p>&quot;the reduction function&quot; it won&#x27;t work
        <p>The kicker:<a href="foobar.com">link body</a>
        <p>> here is commented code<p>Here is not a comment
        <p>content with<p>a new paragraph
        """

    static var previews: some View {
        AttributedTextView(text: text)
            .frame(maxWidth: 300)
            .previewLayout(.sizeThatFits)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}
