//
//  NavigationCustomTitleView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct NavigationCustomTitleView<Title: View, Content: View>: View {
    @ViewBuilder var title: () -> Title
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationTitlelessView {
            VStack(spacing: 0) {
                title()
                Divider()
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

struct NavigationCustomTitleView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationCustomTitleView {
            Text("Title")
        } content: {
            Text("Content")
        }

    }
}
