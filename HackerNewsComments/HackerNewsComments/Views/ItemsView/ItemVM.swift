//
//  ItemVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 29/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import SwiftUI

class ItemVM: ObservableObject {
    @Published var item: HackerNewsItem

    lazy var id: Int = { item.id }()
    lazy var author: String = { item.author }()
    lazy var commentCount: Int = { item.commentCount }()
    lazy var hostText: String = {
        guard let host = URL(string: item.url ) else { return "404.com" }
        return host.host ?? "404"
    }()
    lazy var kids: [Int] = { item.kids ?? [] }()
    lazy var score: Int = { item.score }()
    lazy var title: String = { item.title }()
    lazy var url: String = { item.url }()


    lazy var commentsText: LocalizedStringKey = {
        let numberOfComments = commentCount
        let singleKey: LocalizedStringKey = "1 item-comment"
        let pluralKey: LocalizedStringKey = "\(commentCount) item-comments"
        return numberOfComments == 1 ? singleKey : pluralKey
    }()

    init(_ item: HackerNewsItem? = nil) {
        self.item = item ?? .Empty
    }
}
