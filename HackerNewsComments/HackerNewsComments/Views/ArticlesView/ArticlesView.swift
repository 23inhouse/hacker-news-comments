//
//  ArticlesView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import Combine
import SwiftUI

struct ArticlesView: View {
    let items: [HackerNewsItem]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                NavigationLink {
                    CommentsView()
                } label: {
                    ArticleView(item: item)
                        .padding(10)
                }
                Divider()
            }
        }
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static let item1 = HackerNewsItem(title: "First one with text", commentCount: 0)
    static let item2 = HackerNewsItem(title: "First one with text", commentCount: 1)
    static let item3 = HackerNewsItem(title: "First one with text", commentCount: 2)

    static var previews: some View {
        ArticlesView(items: [item1, item2, item3])
            .previewLayout(.sizeThatFits)
    }
}
