//
//  ContentView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var itemsVM = ItemsVM()

    var body: some View {
        NavigationCustomTitleView {
            SearchBarView() { text in
                itemsVM.newsItemFilter = text
            }
            .padding(7)
        } content: {
            if #available(iOS 15.0, *) {
                RefreshableScrollView {
                    ItemsView(vm: itemsVM)
                } refreshAction: {
                    itemsVM.requestData()
                }
            } else {
                ScrollView {
                    ItemsView(vm: itemsVM)
                }
            }

        }
        .onAppear(perform: requestData)
    }

    private func requestData() {
        itemsVM.requestData()
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
            .background(Color.secondary)
    }
}
