//
//  NavigationTitlelessView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct NavigationTitlelessView<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        NavigationView {
            content()
                .frame(maxWidth: .infinity)
                .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct NavigationTitlelessView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationTitlelessView() {
            VStack {
                Text("Hi")
                Spacer()
            }
        }
        .background(Color.secondary)
    }
}
