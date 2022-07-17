//
//  String+TrimWhiteSpaces.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 17/7/2022.
//

import Foundation

extension String {
    func trimLeadingWhitespaces() -> String {
        return self.replacingOccurrences(of: "^\\s+", with: "", options: .regularExpression)
    }

    func trimTrailingWhitespaces() -> String {
        return self.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
