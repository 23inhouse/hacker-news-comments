//
//  Int+Of.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 28/6/2022.
//

import SwiftUI

extension Int {
    func of(_ name: String) -> LocalizedStringKey {
        var singular: String
        var plural: String
        switch name {
        case "second":
            singular = "1 second-ago"
            plural = "%lld seconds-ago"
        case "minute":
            singular = "1 minute-ago"
            plural = "%lld minutes-ago"
        case "hour":
            singular = "1 hour-ago"
            plural = "%lld hours-ago"
        case "day":
            singular = "1 day-ago"
            plural = "%lld days-ago"
        case "week":
            singular = "1 week-ago"
            plural = "%lld weeks-ago"
        case "month":
            singular = "1 month-ago"
            plural = "%lld months-ago"
        case "year":
            singular = "1 year-ago"
            plural = "%lld years-ago"
        default:
            singular = ""
            plural = ""
        }
        guard self != 1 else { return LocalizedStringKey(String(format: NSLocalizedString(singular, comment: ""))) }
        return LocalizedStringKey(String(format: NSLocalizedString(plural, comment: ""), self))
    }
}

struct Int_Of_Previews: PreviewProvider {
    static let periods = ["second", "minute", "hour", "day", "week", "month", "year"]

    static var previews: some View {
        VStack {
            ForEach(periods, id: \.self) { period in
                Text(1.of(period))
                Text(2.of(period))
                Divider()
            }
        }
        .frame(width: 200)
        .previewLayout(.sizeThatFits)
    }
}
