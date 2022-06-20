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
            Image(systemName: "chevron.backward")
                .padding()
        }
    }
}

struct NavigationBackButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBackButton()
    }
}
