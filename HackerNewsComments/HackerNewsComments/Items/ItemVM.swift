//
//  ItemVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 29/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import Foundation

class ItemVM: ObservableObject {
  @Published var item: HackerNewsItem?

  lazy var id: Int = { item?.id ?? 0 }()
  lazy var author: String = { item?.author ?? "" }()
  lazy var commentCount: Int = { item?.commentCount ?? 0 }()
  lazy var host: String = {
      guard let host = URL(string: item?.url ?? "") else { return "404.com" }
      return host.host ?? "404"
  }()
  lazy var kids: [Int] = { item?.kids ?? [] }()
  lazy var score: Int = { item?.score ?? 0 }()
  lazy var title: String = { item?.title ?? "title" }()
  lazy var url: String = { item?.url ?? "url" }()

  init(_ item: HackerNewsItem? = nil) {
    self.item = item
  }
}
