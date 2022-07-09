//
//  CGFloat+Rounded.swift
//  HackerNewsComments
//
//  Created by Benjamin Lewis on 11/7/2022.
//

import UIKit

extension CGFloat {
    func rounded(to places: Int) -> CGFloat {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
