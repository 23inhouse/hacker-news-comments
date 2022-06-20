//
//  SearchBarView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct SearchBarView: View {
    var onCommit: (String) -> Void

    @State private var searchText = ""
    @State private var showCancelButton: Bool = false

    private var isShowingXMark: Bool { !searchText.isEmpty }

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")

                Group {
                    if #available(iOS 15.0, *) {
                        TextField("search-bar.prompt", text: $searchText) { isEditing in
                            showCancelButton = isEditing
                        } onCommit: {
                            onCommit(searchText)
                        }
                        .submitLabel(.search)
                    } else {
                        TextField("search-bar.prompt", text: $searchText) { isEditing in
                            showCancelButton = isEditing
                        } onCommit: {
                            onCommit(searchText)
                        }
                    }
                }
                .foregroundColor(.primary)

                Button {
                    xMarkButtonAction()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(isShowingXMark ? 1 : 0)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)

            if showCancelButton  {
                Button {
                    cancelButtonAction()
                } label: {
                    Text("search-bar.cancel")
                        .foregroundColor(Color(.systemBlue))
                }
            }
        }
    }

    private func xMarkButtonAction() {
        searchText = ""
    }

    private func cancelButtonAction() {
        UIApplication.shared.endEditing(true)
        searchText = ""
        showCancelButton = false
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView() { text in
            print("onCommit")
        }
    }
}
