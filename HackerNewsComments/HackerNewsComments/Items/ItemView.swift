//
//  ItemView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 29/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import SwiftUI

struct ItemView: View {
  private var item: ItemVM

  var body: some View {
    VStack(alignment: .leading, spacing: 5) {
      Text(item.title)
        .frame(minHeight: 40)
      HStack {
        Text("\(item.commentCount) comments")
        Spacer()
        Text(item.host)
      }
      .font(.caption)
    }
    .frame(height: 70)
  }

  init(_ item: ItemVM) {
    self.item = item
  }
}

struct ItemView_Previews: PreviewProvider {
  static var previews: some View {
    ItemView(ItemVM())
  }
}
