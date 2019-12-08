//
//  Binary Structure.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/7.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol Semigroup {
            
    static var cardinality: Cardinality { get }
    static var isCommutative: Bool { get }
    
    static func combine(_ element1: Self, _ element2: Self) -> Self
    func combinesWith(_ other: Self) -> Self
}
