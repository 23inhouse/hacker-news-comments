//
//  NavigationBackButton.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.backward")
                Text("Back")
            }
            .padding()
        }
    }
}

struct NavigationBackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBackButton()
    }
}
