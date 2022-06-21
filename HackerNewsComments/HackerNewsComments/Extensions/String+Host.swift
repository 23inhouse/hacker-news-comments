//
//  String+Host.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 21/6/2022.
//

import Foundation

extension String {
    var host: String? {
        guard let url = URL(string: self) else { return nil }
        return url.host
    }
}
