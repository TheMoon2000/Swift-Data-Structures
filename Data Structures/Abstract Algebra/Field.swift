//
//  File.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol Field: RingWithUnity {
    static func / (lhs: Self, rhs: Self) -> Self
}


extension Field {
    var isCommutative: Bool { return true }
}
