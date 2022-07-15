//
//  WebView.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 13/7/2022.
//

import SwiftUI
import WebKit

struct WebView: View {
    @Binding var url: URL?

    var body: some View {
        SafariView(url: url)
            .ignoresSafeArea()
    }
}

import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url: URL?

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        let notFoundURL = URL(string: "https://img.freepik.com/vektoren-kostenlos/fehler-seite-404-fehler_23-2148105404.jpg")!
        let url = url ?? notFoundURL

        let sfSafariViewController = SFSafariViewController(url: url)
        sfSafariViewController.configuration.entersReaderIfAvailable = true
        return sfSafariViewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
    }
}
