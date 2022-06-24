//
//  HackerNewsCommentFormatterTests.swift
//  HackerNewsTests
//
//  Created by Benjamin Lewis on 6/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import XCTest
@testable import HackerNewsComments

class HackerNewsCommentFormatterTests: XCTestCase {
    func testCall() {
        let htmlText = "<p>text</p>"
        let attributedText = HackerNewsCommentFormatter.call(htmlText)

        let expectText = "text"
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
    }

    func testCallWithParagraphs() {
        let htmlText = "<p>text</p><p>text</p>"
        let attributedText = HackerNewsCommentFormatter.call(htmlText)
        let attributedString = String(describing: attributedText)
        let paragraphStlyes = attributedString.split(separator: " ").filter({$0 == "NSParagraphStyle"})

        let expectText = "text\ntext"
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
        XCTAssertEqual(paragraphStlyes.count, 2, "Wrong number of paragraphs")
    }

    func testCallWithItalic() {
        let htmlText = "&gt; My C&#x2F;C++ code is as boring as possible."
        let attributedText = HackerNewsCommentFormatter.call(htmlText)
        let attributedString = String(describing: attributedText)

        let expectText = "> My C/C++ code is as boring as possible."
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
        XCTAssertNotNil(attributedString.range(of: "font-style: italic;"), "Didn't find the font style italic")
    }

    func testCallWithLink() {
        let htmlText = "Check this out https://rick.roll.com/never/gunna/give?you=up&again"
        let attributedText = HackerNewsCommentFormatter.call(htmlText)
        let attributedString = String(describing: attributedText)

        let expectText = "Check this out https://rick.roll.com/never/gunna/give?you=up&again"
        XCTAssertEqual(attributedText.string, expectText, "Wrong formatted text")
        XCTAssertNotNil(attributedString.range(of: "NSLink = \"https://rick.roll.com/never/gunna/give?you=up&again\""), "Didn't find the link")
    }
}
