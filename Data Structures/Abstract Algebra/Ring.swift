//
//  Ring.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol Ring: Group {
    static func * (lhs: Self, rhs: Self) -> Self
}

protocol RingWithUnity: Ring {
    static var unity: Self { get }
}

extension Ring {
    static var zero: Self { return identity }
}
