//
//  FirebaseQuery.swift
//  HackerNews
//
//  Created by Benjamin Lewis on 3/7/19.
//  Copyright © 2019 Benjamin Lewis. All rights reserved.
//

import Firebase

class FirebaseQuery: Queryable {
    private var firebase = Database.database(url: FirebaseConfig.Url).reference()

    lazy var topStoryQuery: FirebaseTopStoryQuery = { closure in
        let query = self.firebase
            .child(FirebaseConfig.TypeChildRef)
            .queryLimited(toFirst: FirebaseConfig.ItemLimit)
        query.observeSingleEvent(of: DataEventType.value, with: closure)
    }

    lazy var itemQuery: FirebaseItemQuery = { (id, closure) in
        let query = self.firebase
            .child(FirebaseConfig.ItemChildRef)
            .child(String(id))
        query.observeSingleEvent(of: .value, with: closure)
    }
}

extension DataSnapshot: Snapshottable {}
