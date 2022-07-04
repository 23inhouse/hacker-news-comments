//
//  HackerNewsCommentFormatter.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 4/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import UIKit

struct HackerNewsCommentFormatter {
    typealias Formatter = (inout NSMutableAttributedString) -> Void
    typealias Attribute = [NSAttributedString.Key: Any]

    static let fontSize: CGFloat = 18
    static let paragraphSpacing: CGFloat = 15

    static private let formatters: [Formatter] = [
        paragraph,
        comment,
        link,
    ]

    static private let paragraph: Formatter = { text in
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.paragraphSpacing = paragraphSpacing
        setAttribute(&text, with: [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: UIColor.darkGray,
            ])
    }

    static private let comment: Formatter = { text in
        guard text.string.first == ">" else { return }
        setAttribute(&text, with: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.italicSystemFont(ofSize: fontSize),
            ])
    }

    static private let link: Formatter = { text in
        let input = text.string
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return }
        let matches = detector.matches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count))

        for match in matches {
            guard let range = Range(match.range, in: input) else { continue }
            let url = String(input[range])
            let attributedRange = text.mutableString.range(of: url)
            text.addAttribute(.link, value: url, range: attributedRange)
        }
    }

    static func call(_ text: String) -> NSAttributedString {
        let texts = text.htmlToString.split(separator: "\n")

        let mutatableText = NSMutableAttributedString(string: "")
        texts.enumerated().forEach { (i, text) in
            var text = NSMutableAttributedString(string: String(text))
            formatters.forEach({ formatter in formatter(&text) })
            mutatableText.append(text)

            guard i < texts.count - 1 else { return }
            mutatableText.append(NSAttributedString(string: "\n"))
        }

        return mutatableText
    }

    static private func setAttribute(_ text: inout NSMutableAttributedString, with attribute: Attribute) {
        text.addAttributes(attribute, range: NSRange(location: 0, length: text.length))
    }
}
