//
//  CommentsView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct CommentsView: View {
    @ObservedObject var commentsVM: CommentsVM

    var comments: [HackerNewsComment] {
        commentsVM.toggledComments
    }

    var itemURL: URL {
        let notFoundURL = URL(string: "https://img.freepik.com/vektoren-kostenlos/fehler-seite-404-fehler_23-2148105404.jpg")!
        return URL(string: commentsVM.item.url) ?? notFoundURL
    }

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
                VStack(spacing: 0) {
                    Link(destination: itemURL) {
                        ItemView(vm: ItemVM(commentsVM.item))
                            .padding(10)
                    }
                    .foregroundColor(.primary)

                    ForEach(Array(comments.enumerated()), id: \.element.identifier) { index, comment in
                        VStack(spacing: 0) {
                            Divider()
                                .padding(.leading, index < 1 ? 0 : 10)
                            CommentView(commentVM: CommentVM(comment: comment)) {
                                commentsVM.toggle(comment: comment)
                            }
                            .padding(10)
                        }
                        .padding(.leading, CGFloat(comment.nestedLevel * 10))
                        .background(Color.background)
                    }

                    Divider()
                        .background(Color.background)
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
