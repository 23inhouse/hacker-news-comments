//
//  CommentVM.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 23/6/2022.
//

import SwiftUI

struct CommentVM {
    let comment: HackerNewsComment

    var body: NSAttributedString { comment.body }
    var date: LocalizedStringKey { date(since: comment.timestamp ?? Date()) }
    var username: String { comment.username }

    private func date(since fromDate: Date) -> LocalizedStringKey {
        guard fromDate < Date() else { return "back-to-the-future" }

        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components: DateComponents = Calendar.current.dateComponents(allComponents, from: fromDate, to: Date())

        let periods: [(String, Int)] = [
            ("year", components.year ?? 0),
            ("month", components.month ?? 0),
            ("week", components.weekOfYear ?? 0),
            ("day", components.day ?? 0),
            ("hour", components.hour ?? 0),
            ("minute", components.minute ?? 0),
            ("second", components.second ?? 0),
        ]

        for (period, timeAgo) in periods where timeAgo > 0 {
            return timeAgo.of(period)
        }

        return "just-now"
    }
}
