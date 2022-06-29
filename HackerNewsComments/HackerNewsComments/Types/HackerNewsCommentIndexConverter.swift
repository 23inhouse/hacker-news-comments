//
//  HackerNewsCommentIndexConverter.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 13/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Foundation

struct HackerNewsCommentIndexConverter {
    let togglable: Togglable

    init(_ togglable: Togglable) {
        self.togglable = togglable
    }

    func convert(from identifier: Int) -> Int? {
        let flattenedComments = togglable.flattenedComments
        return flattenedComments.firstIndex(where: { comment in comment.identifier == identifier })
    }
}
