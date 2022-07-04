//
//  HackerNewsFilter.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 29/6/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

protocol Filterable {
    var newsItems: [HackerNewsItem] { get }
    var newsItemFilter: String { get }
}

struct HackerNewsFilter {
    let filterable: Filterable

    init(_ filterable: Filterable) {
        self.filterable = filterable
    }

    func filteredItems() -> [HackerNewsItem] {
        let newsItems = filterable.newsItems
        let newsItemFilter = filterable.newsItemFilter

        guard newsItemFilter.count > 0 else { return newsItems }

        let filters = newsItemFilter.lowercased().split(separator: " ")

        return newsItems.filter { newsItem -> Bool in
            for filter in filters {
                if !newsItem.title.lowercased().contains(filter) { return false }
            }
            return true
        }
    }
}
