//
//  Cardinality.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

struct Cardinality: Equatable, Comparable {
    
    enum `Type`: Int {
        case uncountable = 2, countable = 1, finite = 0
    }
    
    var type: Type
    var count: Int = -1
    static let uncountable = Cardinality(type: .uncountable)
    static let countable = Cardinality(type: .countable)
    
    init(type: Type, numberOfElements: Int? = nil) {
        self.type = type
        self.count = numberOfElements ?? -1
    }
    
    static func < (lhs: Cardinality, rhs: Cardinality) -> Bool {
        if lhs.type != rhs.type { return false }
        return lhs.count == rhs.count
    }
}

