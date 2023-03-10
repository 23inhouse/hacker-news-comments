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

    private var validNewsItems: [HackerNewsItem] {
        filterable.newsItems.filter(\.isValid)
    }

    func filteredItems() -> [HackerNewsItem] {
        let newsItems = validNewsItems
        let newsItemFilter = filterable.newsItemFilter

        guard newsItemFilter.count > 0 else { return newsItems }

        let filters = newsItemFilter.lowercased().split(separator: " ")

        return newsItems.filter { newsItem -> Bool in
            for filter in filters {
                if !contains(filter, in: newsItem) { return false }
            }
            return true
        }
    }

    private func contains(_ filter: String.SubSequence, in item: HackerNewsItem) -> Bool {
        item.title.lowercased().contains(filter) ||
        item.url.lowercased().contains(filter)
    }
}
