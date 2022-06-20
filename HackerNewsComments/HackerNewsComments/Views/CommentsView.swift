//
//  CommentsView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct CommentsView: View {
    var body: some View {
        NavigationCustomTitleView {
            HStack(spacing: 0) {
                NavigationBackButton()

                Text(" ")
                    .padding()
                    .opacity(0)

                Spacer()
            }
            .frame(maxWidth: .infinity)
        } content: {
            VStack(spacing: 0) {
                Text("Comments View")

                Spacer()
            }
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
