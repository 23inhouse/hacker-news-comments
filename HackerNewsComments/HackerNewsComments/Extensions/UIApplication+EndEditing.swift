//
//  UIApplication+EndEditing.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 20/6/2022.
//

import UIKit

extension UIApplication {
    func endEditing(_ force: Bool) {
        if #available(iOS 15.0, *) {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            window?.endEditing(force)
        } else {
            self.windows
                .filter{$0.isKeyWindow}
                .first?
                .endEditing(force)
        }
    }
}
