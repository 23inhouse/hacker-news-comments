//
//  ArticleView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 21/6/2022.
//

import SwiftUI

struct ArticleView: View {
    let item: HackerNewsItem

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.title)
                .lineLimit(2)
                .font(.title3)
                .frame(minHeight: 50)
            HStack(spacing: 0) {
                numberOfCommentsView
                Spacer()
                Text(item.host)
            }
            .font(.callout)
        }
    }

    var numberOfCommentsView: some View {
        let numberOfComments = item.numberOfComments
        let stringKey: LocalizedStringKey = numberOfComments == 1 ? "1 item-comment" : "\(numberOfComments) item-comments"
        return Text(stringKey)
    }
}

struct ArticleView_Previews: PreviewProvider {
    static let item = HackerNewsItem(title: "First one with text", commentCount: 0)
    static let itemWithOneComment = HackerNewsItem(title: "First one with text", commentCount: 1)
    static let itemWithComments = HackerNewsItem(title: "First one with text", commentCount: 2)
    static let longTitle = "Very long title that could go over many many lines and will in fact go over many many lines at least three of them"
    static let itemWithLongTitle = HackerNewsItem(title: longTitle, commentCount: 0)

    static var previews: some View {
        Group {
            ArticleView(item: item)
            ArticleView(item: itemWithOneComment)
            ArticleView(item: itemWithComments)
            ArticleView(item: itemWithLongTitle)
        }
        .previewLayout(.sizeThatFits)
    }
}
