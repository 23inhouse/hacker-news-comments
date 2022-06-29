//
//  ItemsVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 29/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import SwiftUI

class ItemsVM: ObservableObject {
    @Published var newsItems = (0..<6).map { _ in HackerNewsItem.Empty }
    @Published var filteredNewsItems: [HackerNewsItem] = []

    var newsItemFilter: String = "" {
        willSet {
            print("didSet newsItemFilter")
            filteredNewsItems = HackerNewsFilter(self).filteredItems()
        }
    }

    private lazy var firebaseRequest = FirebaseAPI(self)

    func requestData() {
        DispatchQueue.main.async {
            self.firebaseRequest.call()
//            self.filteredNewsItems = self.newsItems
        }
    }
}

extension ItemsVM: Requestable {
    func setData(_ data: [Datable]) {
        newsItems = data as! [HackerNewsItem]
//        filteredNewsItems = HackerNewsFilter(self).filteredItems()
    }

    func setData(at index: Int, with data: Datable) {
        newsItems[index] = data as! HackerNewsItem
//        filteredNewsItems = HackerNewsFilter(self).filteredItems()
    }
}

extension ItemsVM: Filterable {}
