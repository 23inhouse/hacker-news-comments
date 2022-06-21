//
//  Item.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 21/6/2022.
//

import Foundation

struct Item {
    let id: Int
    let title: String?
    let by: String?
    let time: TimeInterval
    let score: Int?
    let url: String?
    let kids: [Int]?

    var titleDescription: String { title ?? "No title" }
    var host: String { url?.host ?? "No Url" }

    var children: [Item] = []
    var numberOfComments: Int {
        children.map(\.numberOfComments).reduce(0, +) + children.count
    }
}

extension Item: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case by
        case time
        case score
        case url
        case kids
    }
}
extension Item: Identifiable {}
