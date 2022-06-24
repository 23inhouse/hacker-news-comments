//
//  HTML2TextParser.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 27/6/2022.
//

import SwiftUI

class HTML2TextParser: XMLParser {
    static func text(from string: String) -> some View {
        let parsableString = "<p>\(string.replacingOccurrences(of: "<p>", with: "</p><p>"))</p>"

        let regex = "([^\"])(https?://[^<>\"\\s]+)"
        let replacement = "$1<a>$2</a>"
        let markedUpString = parsableString.replacingOccurrences(of: regex, with: replacement, options: [.regularExpression])

        let data = Data("<XML>\(markedUpString)</XML>".utf8)
        let parser = HTML2TextParser(data: data)

        parser.delegate = parser
        if !parser.parse() {
            print("Error: Faild with: ", string)
        }

        return VStack(alignment: .leading, spacing: 15) {
            ForEach(Array(parser.resultText.enumerated()), id: \.offset) { text in
                text.element
            }
        }
    }

    private var isBold: Bool  = false
    private var isItalic: Bool  = false
    private var isLink: Bool  = false
    private var isNewParagraph: Bool = false
    private var isComment: Bool = false

    var resultText: [Text] = [Text("")]

    override init(data: Data) {
        super.init(data: data)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if string.first == ">" {
            isComment = true
        }
        addChunkOfText(contentText: string)
    }

    private func addChunkOfText(contentText: String) {
        guard contentText != "" else { return }

        if isNewParagraph {
            resultText.append(Text(""))
            isNewParagraph = false
        }

        var textChunk = Text(contentText)
        textChunk = isBold ? textChunk.bold() : textChunk
        textChunk = isItalic ? textChunk.italic() : textChunk
        textChunk = isLink ? textChunk.foregroundColor(.blue) : textChunk
        textChunk = isComment ? textChunk.foregroundColor(.secondary).italic() : textChunk
        resultText[resultText.count - 1] = resultText.last! + textChunk
    }
}

extension HTML2TextParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        if elementName.uppercased() == "B" {
            isBold = true
        } else if elementName.uppercased() == "I" {
            isItalic = true
        } else if elementName.uppercased() == "A" {
            isLink = true
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName.uppercased() == "B" {
            isBold = false
        } else if elementName.uppercased() == "I" {
            isItalic = false
        } else if elementName.uppercased() == "A" {
            isLink = false
        } else if elementName.uppercased() == "P" {
            isNewParagraph = true
            isComment = false
        }
    }
}


struct HTML2TextParser_Previews: PreviewProvider {
    static let texts = [
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
        The kicker:<a href="http://foobar.com">link body</a>
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

    static var previews: some View {
        VStack(spacing: 0) {
            ForEach(texts, id: \.self) { text in
                HTML2TextParser.text(from: text)
                Divider()
            }
        }.previewLayout(.sizeThatFits)
    }
}
