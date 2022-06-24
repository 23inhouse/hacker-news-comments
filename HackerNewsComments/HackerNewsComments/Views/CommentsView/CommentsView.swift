//
//  CommentsView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct CommentsView: View {
    @StateObject var commentsVM: CommentsVM

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 5) {
                NavigationBackButton()

                Text(" ")
                    .padding()
                    .opacity(0)

                Spacer()
            }
            .frame(maxWidth: .infinity)
            Divider()
            ScrollView {
                LazyVStack(spacing: 0) {
                    ItemView(vm: ItemVM(commentsVM.item))
                        .padding(10)
                    Divider()

                    ForEach(commentsVM.flattedComments, id: \.identifier) { comment in
                        VStack(spacing: 0) {
                            CommentView(commentVM: CommentVM(comment: comment))
                                .padding(10)
                            Divider()
                                .padding(.leading, 10)
                        }
                        .padding(.leading, CGFloat(comment.nestedLevel * 10))
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear(perform: requestData)
    }

    private func requestData() {
        commentsVM.requestData()
    }
}

struct CommentsView_Previews: PreviewProvider {
    static let item = HackerNewsItem(title: "item title", commentCount: 99)

    static var previews: some View {
        CommentsView(commentsVM: CommentsVM(item: item))
            .previewLayout(.sizeThatFits)
    }
}
