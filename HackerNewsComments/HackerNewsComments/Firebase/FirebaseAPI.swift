//
//  FirebaseAPI.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 5/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Firebase
import Foundation

class FirebaseAPI: Firebasable {
    var requestable: Requestable
    let queryable: Queryable

    static func firebaseQuery() -> Queryable {
//        return TestFirebaseQuery()
//        guard !CommandLine.arguments.contains("-firebaseTest") else { return TestFirebaseQuery() }
        return FirebaseQuery()
    }

    init(_ requestable: Requestable, _ queryable: Queryable = FirebaseAPI.firebaseQuery()) {
        self.requestable = requestable
        self.queryable = queryable
    }

    func call() {
        queryable.topStoryQuery { snap in
            guard let ids = snap?.value as? [Int] else { return }

            self.requestable.setData((0..<ids.count).map { _ in HackerNewsItem.Empty })

            for id in ids {
                self.queryable.itemQuery(id) { snap in
                    guard let newsItem = HackerNewsItem(data: snap!) else { return }
                    let index = ids.firstIndex(of: id)!
                    self.requestable.setData(at: index, with: newsItem)
                }
            }
        }
    }

    func call(_ id: Int, includeKids: Bool = true) {
        queryable.itemQuery(id) { snap in
            guard let newsItem = HackerNewsItem(data: snap!) else { return }
            self.requestable.setData(at: 0, with: newsItem)

            guard includeKids else { return }
            self.request(ids: newsItem.kids)
        }
    }

    private func request(ids: [Int]?) {
        guard let ids = ids else { return }
        guard !ids.isEmpty else { return }

        var commentsMap: [Int: HackerNewsFirebaseComment] = [:]

        for id in ids {
            queryable.itemQuery(id) { snap in

                commentsMap[id] = HackerNewsFirebaseComment(data: snap!) ?? HackerNewsFirebaseComment.Empty(0)

                guard commentsMap.count == ids.count else { return }

                var sortedComments = [HackerNewsFirebaseComment]()
                for id in ids {
                    let comment = commentsMap[id] ?? HackerNewsFirebaseComment.Empty(0)
                    sortedComments.append(comment)
                    self.request(ids: comment.kids)
                }

                self.requestable.setData(sortedComments)
            }
        }
    }
}

// MARK: Firebase Query Test mock
class TestFirebaseQuery: Queryable {
    var async: Bool = true
    let simutateNetworkLatency: () -> Void = { usleep(100000) }

    let stories: [Int: (title: String, commentCount: Int, kids: [Int])] = [
        1: ("Open Letter from the OpenID Foundation to Apple Regarding Sign in with Apple", 55, []),
        2: ("NASA plans to launch a spacecraft to Titan", 171, []),
        3: ("How AMD Gave China the 'Keys to the Kingdom'", 108, [11, 14]),
        4: ("The International Space Station is growing mold, inside and outside", 66, []),
        5: ("The Evolution of Lisp (1993) [pdf]", 0, []),
        6: ("Most Unit Testing Is Waste (2014) [pdf]", 93, []),
    ]

    typealias CommentData = [Int: (author: String, parent: Int, kids: [Int], time: Double, text: String)]
    let comments: [CommentData] = [
        [
            11: ("simonh", 3, [12], Date(timeIntervalSinceNow: -39600).timeIntervalSince1970, """
            Put everyone in a numbered sequence unknown to them. Add their chosen number to their sequence number, mod 10.
            This re-maps everyone’s choices so they actually have no idea what number they are actually choosing and efficiently redistributes the bias in their choices without massively complicated functions.
            It is also robust to changes in the distribution pattern. However it would only work well if you had at least 10 people and the number of people is divisible by 10.
            """),
            14: ("terryB", 3, [], Date(timeIntervalSinceNow: -139600).timeIntervalSince1970, "https://rick.roll.com/never/gunna?give=you&up"),
        ],
        [
            12: ("bifel", 11, [13], Date(timeIntervalSinceNow: -1800).timeIntervalSince1970, """
            Wouldn't putting "everyone in a numbered sequence unknown to them" require a link
            <p>http://news.ycombinator.com/item?id=1</p>
            """),
        ],
        [
            13: ("sandworm101", 12, [], Date(timeIntervalSinceNow: -60).timeIntervalSince1970, """
            Modern farming practices really help. The cows/pigs are kept far away, and downhill, of the fields growing vegetables.
            Irrigation water isn't contaminated. Humans are in minimal contact with the crop.
            Like it or not, epic agribusiness dramatically reduces the risk of cross-contamination between crops/livestocks/peoples.
            """),
        ],
    ]

    lazy var topStoryQuery: FirebaseTopStoryQuery = { closure in
        let value = [1, 2, 3, 4, 5, 6]
        let snap = TestSnapshot(value)
        self.simutateNetworkLatency()
        self.observeSingleEvent(snap, closure)
    }

    lazy var itemQuery: FirebaseItemQuery = { (id, closure) in
        let snap = id < 10 ? self.makeNewsSnapshot(for: id) : self.makeCommentSnapshot(for: id)
        self.simutateNetworkLatency()
        self.observeSingleEvent(snap, closure)
    }

    private func observeSingleEvent(_ snap: Snapshottable?, _ closure: @escaping QueryClosure) {
        async ? DispatchQueue.main.async { closure(snap) } : closure(snap)
    }

    private func makeNewsSnapshot(for id: Int) -> Snapshottable? {
        guard let story = stories[id] else { return nil }
        var value: [String: Any]
        value = [
            FirebaseConfig.Key.Id: id,
            FirebaseConfig.Key.Url: "https://127.0.0.1",
            FirebaseConfig.Key.Title: story.title,
            FirebaseConfig.Key.Author: "Mac",
            FirebaseConfig.Key.Score: 0,
            FirebaseConfig.Key.Kids: story.kids,
            FirebaseConfig.Key.CommentCount: story.commentCount,
        ]
        return TestSnapshot(value)
    }

    private func makeCommentSnapshot(for id: Int) -> Snapshottable? {
        var value: [String: Any]

        guard let nestedComments = comments[0][id] ?? comments[1][id] ?? comments[2][id] else { return nil }
        value = [
            FirebaseConfig.Key.Id: id,
            FirebaseConfig.Key.Author: nestedComments.author,
            FirebaseConfig.Key.Text: nestedComments.text,
            FirebaseConfig.Key.Parent: nestedComments.parent,
            FirebaseConfig.Key.Kids: nestedComments.kids,
            FirebaseConfig.Key.Time: nestedComments.time,
        ]
        return TestSnapshot(value)
    }

    init(async: Bool = true) {
        self.async = async
    }
}

struct TestSnapshot: Snapshottable {
    var value: Any?

    init(_ value: Any) {
        self.value = value
    }
}
