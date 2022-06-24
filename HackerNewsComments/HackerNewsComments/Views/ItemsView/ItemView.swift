//
//  ItemView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 21/6/2022.
//

import SwiftUI

struct ItemView: View {
    let vm: ItemVM

    var item: HackerNewsItem { vm.item }
    var isEmpty: Bool { vm.item.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.title)
                .lineLimit(2)
                .font(.body)
                .frame(minHeight: 50)
                .loadingPlaceHolder(isEmpty)
            HStack(spacing: 0) {
                Text(vm.commentsText)
                    .font(.subheadline)
                    .loadingPlaceHolder(isEmpty)
                Spacer()
                Text(vm.hostText)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .loadingPlaceHolder(isEmpty)
            }
            .font(.callout)
        }
    }
}

struct ArticleView_Previews: PreviewProvider {
    static let item = HackerNewsItem(title: "First one with text", commentCount: 0)
    static let longTitle = "Very long title that could go over many many lines and will in fact go over many many lines at least three of them"
    static let itemWithLongTitle = HackerNewsItem(title: longTitle, commentCount: 0)

    static var previews: some View {
        Group {
            ItemView(vm: ItemVM())
            ItemView(vm: ItemVM(item))
            ItemView(vm: ItemVM(itemWithLongTitle))
        }
        .previewLayout(.sizeThatFits)
    }
}
