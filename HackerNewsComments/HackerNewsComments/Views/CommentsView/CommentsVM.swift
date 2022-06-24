//
//  CommentsVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/6/2022.
//

import SwiftUI

class CommentsVM: ObservableObject {
    var item: HackerNewsItem

    @Published var comments = (0..<6).map { _ in HackerNewsComment.Empty }
    var flattedComments: [HackerNewsComment] {
        HackerNewsCommentFlattener(self).flattenedComments()
    }

    private lazy var firebaseRequest = FirebaseAPI(self)

    init(item: HackerNewsItem) {
        self.item = item
    }

    func requestData() {
        DispatchQueue.main.async {
            self.firebaseRequest.call(self.item.id)
        }
    }
}

extension CommentsVM: Requestable {
    func setData(_ data: [Datable]) {
        let data = data as! [HackerNewsFirebaseComment]
        guard !data.isEmpty else { return }
        guard data[0].parent != item.id else {
            comments = HackerNewsCommentBridge.call(from: data)
            return
        }

        if let updatedComments = HackerNewsCommentsFactory(comments: comments).makeComments(data) {
            comments = updatedComments
        }
    }

    func setData(at index: Int, with data: Datable) {
        item = data as! HackerNewsItem
    }
}

extension CommentsVM: Flattenable {}
