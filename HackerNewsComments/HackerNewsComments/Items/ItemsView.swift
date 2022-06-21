//
//  ItemsView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/7/20.
//  Copyright © 2020 Benjamin Lewis. All rights reserved.
//

import SwiftUI

struct ItemsView: View {
  @ObservedObject private var itemsVM: ItemsVM

  var body: some View {
    List(itemsVM.filteredNewsItems) { item in
      ItemView(ItemVM(item))
    }
//    .onAppear(perform: requestData)
  }

//  private func requestData() {
//    DispatchQueue.global(qos: .background).async {
//      self.itemsVM.requestData()
//    }
//  }

  init(_ itemsVM: ItemsVM) {
    print("ItemView - init")
    self.itemsVM = itemsVM
//    itemsVM.requestData()
  }

//  init(filter: Binding<String>) {
//    print("filter: \(filter)")
//    _filter = filter
//    self.itemsVM = ItemsVM(filter: filter)
//  }
}

//struct ItemsView_Previews: PreviewProvider {
//  static var previews: some View {
//    ItemsView(ItemsVM(filter: $filter))
//  }
//}
