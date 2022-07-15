//
//  ItemsVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 29/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import SwiftUI

class ItemsVM: ObservableObject {
    var newsItems: [HackerNewsItem] = []
    @Published var filteredNewsItems: [HackerNewsItem] = (0..<6).map { _ in HackerNewsItem.Empty }

    var newsItemFilter: String = "" {
        didSet {
            filteredNewsItems = HackerNewsFilter(self).filteredItems()
        }
    }

    private lazy var firebaseRequest = FirebaseAPI(self)

    func requestData() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.firebaseRequest.call()
        }
    }
}

extension ItemsVM: Requestable {
    func setData(_ data: [Datable]) {
        newsItems = data as! [HackerNewsItem]
        filteredNewsItems = HackerNewsFilter(self).filteredItems()
    }

    func setData(at index: Int, with data: Datable) {
        newsItems[index] = data as! HackerNewsItem
        filteredNewsItems = HackerNewsFilter(self).filteredItems()
    }
}

extension ItemsVM: Filterable {}
