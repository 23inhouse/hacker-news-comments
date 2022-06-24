//
//  ItemsView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import Combine
import SwiftUI

struct ItemsView: View {
    @ObservedObject var vm: ItemsVM

    var items: [HackerNewsItem] { vm.newsItems }

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items, id: \.id) { item in
                NavigationLink {
                    CommentsView(commentsVM: CommentsVM(item: item))
                } label: {
                    ItemView(vm: ItemVM(item))
                        .foregroundColor(.primary)
                        .padding(10)
                }
                Divider()
            }
        }
    }
}

struct ItemsView_Previews: PreviewProvider {
    static var itemsVM: ItemsVM {
        let item1 = HackerNewsItem(title: "First one with text", commentCount: 0)
        let item2 = HackerNewsItem(title: "First one with text", commentCount: 1)
        let item3 = HackerNewsItem(title: "First one with text", commentCount: 2)

        let vm = ItemsVM()
        vm.setData([item1, item2, item3])
        return vm
    }

    static var previews: some View {
        Group {
            ItemsView(vm: ItemsVM())
            ItemsView(vm: itemsVM)
        }
        .previewLayout(.sizeThatFits)
    }
}
