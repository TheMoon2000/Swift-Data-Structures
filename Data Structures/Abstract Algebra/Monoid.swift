//
//  Monoid.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/7.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol Monoid: Semigroup {
    static var identity: Self { get }
}

extension Monoid {
    static func combine(_ elements: [Self]) -> Self {
        return elements.reduce(identity, { result, element in
            return combine(result, element)
        })
    }
}
