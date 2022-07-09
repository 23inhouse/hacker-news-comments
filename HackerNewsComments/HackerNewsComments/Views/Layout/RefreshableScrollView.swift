//
//  RefreshableScrollView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 9/7/2022.
//

import SwiftUI

@available(iOS 15.0, *)
struct RefreshableScrollView<Content: View>: View {
    let content: () -> Content
    let refreshAction: () -> Void

    let refreshDragDistance: CGFloat = 100

    @State private var isRefreshable = false
    @State private var isRefreshing = false
    @State private var offsetStartKeyPosition: CGFloat = 0

    var body: some View {
        ZStack(alignment: .top) {
            if isRefreshing {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(width: 50, height: 50)
            }
            ScrollView {
                ZStack(alignment: .top) {
                    Color.clear.frame(width: 10, height: 1)
                        .background {
                            GeometryReader { geo in
                                Color.clear.preference(key: ViewOffsetKey.self, value: geo.frame(in: .global).origin.y)
                            }
                        }
                    content()
                }
                .animation(.default, value: isRefreshing)
                .onPreferenceChange(ViewOffsetKey.self, perform: handleOffsetChange)
            }
        }
        .background {
            GeometryReader { geo in
                Color.clear.preference(key: ViewOffsetStartKey.self, value: geo.frame(in: .global).origin.y)
            }
        }
        .onPreferenceChange(ViewOffsetStartKey.self, perform: handleOffsetStart)
    }

    func handleOffsetStart(_ offset: CGFloat) {
        offsetStartKeyPosition = offset
    }

    func handleOffsetChange(_ offset: CGFloat) {
        let offset = offset.rounded(to: 1)
        let offsetStartKeyPosition = offsetStartKeyPosition.rounded(to: 1)
        if offset == offsetStartKeyPosition {
            isRefreshable = true
            return
        }

        if isRefreshable && offset < offsetStartKeyPosition {
            isRefreshable = false
        }

        if isRefreshable && !isRefreshing && offset > offsetStartKeyPosition + refreshDragDistance {
            isRefreshing = true
            refreshAction()
            return
        }

        if isRefreshing && offset < offsetStartKeyPosition + 1 {
            isRefreshing = false
        }

    }
}

@available(iOS 15.0, *)
struct RefreshableScrollView_Previews: PreviewProvider {
    static var previews: some View {
        RefreshableScrollView() {
            VStack {
                Text("1")
                Text("2")
                Text("3")
            }
        } refreshAction: {
        }
    }
}

struct ViewOffsetStartKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct ViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}
