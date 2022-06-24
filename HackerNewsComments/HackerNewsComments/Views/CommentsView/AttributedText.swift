//
//  AttributedText.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 27/6/2022.
//

import SwiftUI

struct AttributedText: View {
    let htmlString: String

    init(_ htmlString: String) {
        self.htmlString = htmlString
    }

    var body: some View {
        HTML2TextParser.text(from: htmlString)
    }
}

struct AttributedText_Previews: PreviewProvider {
    static let text =
        """
        <b>Some bold text</b>
        <p><i>Some italic text</i>
        <p>The kicker:<p>&quot;the reduction function&quot; it won&#x27;t work
        <p>The kicker:<a href="foobar.com">link body</a>
        <p>> here is commented code<p>Here is not a comment
        <p>content with<p>a new paragraph
        """

    static var previews: some View {
        AttributedText(text)
            .frame(maxWidth: 300)
            .previewLayout(.sizeThatFits)
    }
}
