//
//  View+LoadingPlaceHolder.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/6/2022.
//

import SwiftUI

extension View {
    func loadingPlaceHolder(_ isVisible: Bool) -> some View {
        modifier(LoadingPlaceHolder(isVisible: isVisible))
    }
}

struct LoadingPlaceHolder: ViewModifier {
    var isVisible: Bool

    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 0 : 1)
            .background(
                GeometryReader { geo in
                    Color.secondary
                        .cornerRadius(geo.size.height * 0.5)
                        .padding(.vertical, geo.size.height * 0.1)
                        .padding(.horizontal, geo.size.height == geo.size.width ? geo.size.height * 0.1 : 0)
                        .opacity(isVisible ? 0.5 : 0)
                }
            )

    }
}

struct View_LoadingPlaceHolder_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            Text("Foo bar baz")
                .loadingPlaceHolder(true)
            Text("Foo bar baz very long line of text that wraps on a second line")
                .loadingPlaceHolder(true)
            Circle()
                .frame(width: 100, height: 100)
                .loadingPlaceHolder(true)
        }
        .frame(width: 300)
        .previewLayout(.sizeThatFits)
    }
}
