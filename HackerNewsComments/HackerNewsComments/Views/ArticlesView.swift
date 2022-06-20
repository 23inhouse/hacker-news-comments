//
//  ArticlesView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct ArticlesView: View {
    var body: some View {
        NavigationCustomTitleView {
            SearchBarView() { text in
                print("onCommit: \(text)")
            }
            .padding(7)
        } content: {
            VStack(spacing: 0) {
                NavigationLink {
                    CommentsView()
                } label: {
                    Text("Comments")
                }
                Spacer()
            }
        }
    }
}

struct ArticlesView_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesView()
    }
}
