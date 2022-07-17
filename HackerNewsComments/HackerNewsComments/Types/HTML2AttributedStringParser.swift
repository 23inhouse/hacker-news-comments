//
//  HTML2AttributedStringParser.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 27/6/2022.
//

import SwiftUI

@available(iOS 15.0, *)
class HTML2AttributedStringParser: XMLParser {
    private var isBold: Bool  = false
    private var isItalic: Bool  = false
    private var isLink: Bool  = false
    private var linkUrl: String? = nil
    private var isNewParagraph: Bool = true
    private var isComment: Bool = false

    var texts: [AttributedString] = []

    init(string: String) {
        var markedUpString: String = string
        markedUpString = HTML2AttributedStringParser.replaceLinks(in: markedUpString)
        markedUpString = HTML2AttributedStringParser.replaceNewLines(in: markedUpString)
        let parsableString = "<p>\(markedUpString.replacingOccurrences(of: "<p>", with: "</p><p>"))</p>"
        let data = Data("<XML>\(parsableString)</XML>".utf8)

        super.init(data: data)

        delegate = self
        if !parse() {
            print("Error: Faild with: ", string)
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        addChunkOfText(string: string)
    }

    private func addChunkOfText(string: String) {
        let (string, isLeadingWhiteSpaceTrimmed, isTrailingWhiteSpaceTrimmed) = replaceWhiteSpace(in: string)

        guard string != "" else { return }

        if isNewParagraph && string.first == ">" {
            isComment = true
        }

        if isNewParagraph {
            texts.append("")
            isNewParagraph = false
        }

        var text: AttributedString
        if isBold {
            let markdown = "**\(string)**"
            let attributedString = try? AttributedString(markdown: markdown)
            text = attributedString ?? AttributedString(string)
        } else if isItalic {
            let markdown = "_\(string)_"
            let attributedString = try? AttributedString(markdown: markdown)
            text = attributedString ?? AttributedString(string)
            if let range = text.range(of: string) {
                text[range].foregroundColor = .secondary
            }
        } else if isLink {
            text = AttributedString(string)
            if let linkUrl = linkUrl {
                text.link = URL(string: linkUrl)
            }
        } else if isComment {
            if string != " " {
                let markdown = "_\(string)_"
                let attributedString = try? AttributedString(markdown: markdown)
                text = attributedString ?? AttributedString(string)
            } else {
                text = AttributedString(string)
            }
            if let range = text.range(of: string) {
                text[range].foregroundColor = .secondary
            }
        } else {
            text = AttributedString(string)
        }

        let index = texts.count - 1
        let paddedText = paddedText(text: text, isLeadingWhiteSpaceTrimmed, isTrailingWhiteSpaceTrimmed)
        texts[index].append(paddedText)
    }

    private func replaceWhiteSpace(in string: String) -> (String, Bool, Bool) {
        var isLeadingWhiteSpaceTrimmed: Bool = false
        var isTrailingWhiteSpaceTrimmed: Bool = false

        var originalString = string
        var string = string

        string = string.trimLeadingWhitespaces()
        if string.count < originalString.count {
            isLeadingWhiteSpaceTrimmed = true
        }
        originalString = string
        string = string.trimTrailingWhitespaces()
        if string.count < originalString.count {
            isTrailingWhiteSpaceTrimmed = true
        }

        return (string, isLeadingWhiteSpaceTrimmed, isTrailingWhiteSpaceTrimmed)
    }

    private func paddedText(text: AttributedString, _ isLeadingWhiteSpaceTrimmed: Bool, _ isTrailingWhiteSpaceTrimmed: Bool) -> AttributedString {
        var paddedText = AttributedString("")
        if isLeadingWhiteSpaceTrimmed {
            paddedText = AttributedString(" ")
        }
        paddedText = paddedText + text
        if isTrailingWhiteSpaceTrimmed {
            paddedText = paddedText + AttributedString(" ")
        }

        return paddedText
    }
}

@available(iOS 15.0, *)
private extension HTML2AttributedStringParser {
    static func replaceLinks(in string: String) -> String {
        let regex = "([^\"])(https?://[^<>\"\\s]+)"
        let replacement = "$1<a href=\"$2\">$2</a>"
        return string.replacingOccurrences(of: regex, with: replacement, options: [.regularExpression])
    }

    static func replaceNewLines(in string: String) -> String {
        let regexDouble = "([^\n])\n\n([^\n])"
        let replacementDouble = "$1<p>$2"
        let stringWithNewLinesAdded = string.replacingOccurrences(of: regexDouble, with: replacementDouble, options: [.regularExpression])
        let regexSingle = "([^\n])\n([^\n])"
        let replacementSingle = "$1 $2"
        return stringWithNewLinesAdded.replacingOccurrences(of: regexSingle, with: replacementSingle, options: [.regularExpression])
    }
}

@available(iOS 15.0, *)
extension HTML2AttributedStringParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName.uppercased() == "B" {
            isBold = true
        } else if elementName.uppercased() == "I" {
            isItalic = true
        } else if elementName.uppercased() == "A" {
            isLink = true
            linkUrl = attributeDict["href"]
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName.uppercased() == "B" {
            isBold = false
        } else if elementName.uppercased() == "I" {
            isItalic = false
        } else if elementName.uppercased() == "A" {
            isLink = false
            linkUrl = nil
        } else if elementName.uppercased() == "P" {
            isNewParagraph = true
            isComment = false
        }
    }
}


@available(iOS 15.0, *)
struct HTML2AttributedStringParser_Previews: PreviewProvider {
    static let inputTexts = [
        """
        Some <b>bold </b>text
        """,
        """
        Some<i> italic</i> text
        """,
        """
        The kicker:<p>&quot;the reduction function&quot; it won&#x27;t work
        """,
        """
        The kicker: <a href="http://foobar.com">link body</a>
        """,
        """
        The first part of some text\n\nwith a double newline and a single\nneweline
        """,
        """
        > here is commented code<p>Here is not a comment
        """,
        """
        ><i>here is italic and commented code</i><p>Here is not a comment
        """,
        """
        content with a > that is not a comment
        """,
        """
        content with<p>a new paragraph
        """,
        """
        some content with a https://foo.bar/baz
        """,
        """
        content with invalid characters ` removed
        """
    ]

    static let text = inputTexts.joined(separator: "<p>")
    static let texts = HTML2AttributedStringParser(string: text).texts


    static var previews: some View {
        VStack(spacing: 15) {
            ForEach(texts, id: \.self) { text in
                Text(text)
                Divider()
            }
        }.previewLayout(.sizeThatFits)
    }
}
