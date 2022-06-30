//
//  CommentsVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/6/2022.
//

import SwiftUI

class CommentsVM: ObservableObject {
    var item: HackerNewsItem

    @Published var comments: [HackerNewsComment] = []
    @Published var flattenedComments: [HackerNewsComment] = []
    @Published var toggledComments: [HackerNewsComment] = []

    private lazy var firebaseRequest = FirebaseAPI(self)

    private var isNumberOfCommentsCorrect: Bool {
        item.commentCount == flattenedComments.map(\.body).filter({ !$0.string.isEmpty }).count
    }

    init(item: HackerNewsItem) {
        self.item = item
        self.toggledComments = (0..<item.commentCount).map { _ in HackerNewsComment.Empty }
    }

    var urlString: String {
        item.url
    }

    func requestData() {
        guard flattenedComments.isEmpty || !isNumberOfCommentsCorrect else { return }

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
            flattenedComments = HackerNewsCommentFlattener(self).flattenedComments()
            toggledComments = HackerNewsCommentToggler(self).toggledComments()
            return
        }

        if let updatedComments = HackerNewsCommentsFactory(comments: comments).makeComments(data) {
            comments = updatedComments
            flattenedComments = HackerNewsCommentFlattener(self).flattenedComments()
            toggledComments = HackerNewsCommentToggler(self).toggledComments()
        }
    }

    func setData(at index: Int, with data: Datable) {
        item = data as! HackerNewsItem
    }
}

extension CommentsVM: Flattenable {}

extension CommentsVM: Togglable {
    func toggle(comment: HackerNewsComment) {
        guard let index = HackerNewsCommentIndexConverter(self).convert(from: comment.identifier) else { return }
        flattenedComments = HackerNewsCommentToggler(self).toggleComments(at: index)
        withAnimation {
            toggledComments = HackerNewsCommentToggler(self).toggledComments()
        }
    }
}
