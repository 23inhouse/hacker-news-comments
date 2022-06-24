//
//  CommentView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/6/2022.
//

import SwiftUI

struct CommentView: View {
    let commentVM: CommentVM

    var isEmpty: Bool { commentVM.comment.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 0) {
                Text(commentVM.username)
                    .font(.subheadline)
                    .loadingPlaceHolder(isEmpty)
                Spacer()
                Text(commentVM.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .loadingPlaceHolder(isEmpty)
            }
            if !commentVM.body.string.isEmpty {
                AttributedText(commentVM.body.string)
                    .font(.body)
                    .loadingPlaceHolder(isEmpty)
            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static let comment = HackerNewsComment(body: "comment body<p><a href=\"foobar.com\">Link</a>", username: "username", timestamp: Date())

    static var previews: some View {
        Group {
            CommentView(commentVM: CommentVM(comment: .Empty))
            CommentView(commentVM: CommentVM(comment: comment))
        }
        .previewLayout(.sizeThatFits)
    }
}
