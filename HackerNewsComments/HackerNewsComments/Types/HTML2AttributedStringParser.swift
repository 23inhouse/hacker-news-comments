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
    private var isNewParagraph: Bool = false
    private var isComment: Bool = false

    var texts: [AttributedString] = [""]

    init(string: String) {
        let parsableString = "<p>\(string.replacingOccurrences(of: "<p>", with: "</p><p>"))</p>"
        let markedUpString = HTML2AttributedStringParser.replaceLinks(in: parsableString)
        let data = Data("<XML>\(markedUpString)</XML>".utf8)

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
        guard string != "" else { return }

        if string.first == ">" {
            isComment = true
        }

        if isNewParagraph {
            texts.append("")
            isNewParagraph = false
        }


        var text: AttributedString
        if isBold {
            let markdomn = "**\(string)**"
            let attributedString = try? AttributedString(markdown: markdomn)
            text = attributedString ?? AttributedString(string)
        } else if isItalic {
            let markdomn = "_\(string)_"
            let attributedString = try? AttributedString(markdown: markdomn)
            text = attributedString ?? AttributedString(string)
        } else if isLink {
            text = AttributedString(string)
            if let linkUrl = linkUrl {
                text.link = URL(string: linkUrl)
            }
        } else if isComment {
            text = AttributedString(string)
            let range = text.range(of: string)!
            text[range].foregroundColor = .secondary
        } else {
            text = AttributedString(string)
        }

        let index = texts.count - 1
        texts[index].append(text)
    }
}

@available(iOS 15.0, *)
private extension HTML2AttributedStringParser {
    static func replaceLinks(in string: String) -> String {
        let regex = "([^\"])(https?://[^<>\"\\s]+)"
        let replacement = "$1<a href=\"$2\">$2</a>"
        return string.replacingOccurrences(of: regex, with: replacement, options: [.regularExpression])
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
        <b>Some bold text</b>
        """,
        """
        <i>Some italic text</i>
        """,
        """
        The kicker:<p>&quot;the reduction function&quot; it won&#x27;t work
        """,
        """
        The kicker: <a href="http://foobar.com">link body</a>
        """,
        """
        > here is commented code<p>Here is not a comment
        """,
        """
        content with<p>a new paragraph
        """,
        """
        some content with a https://foo.bar/baz
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
