//
//  Extensions.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

extension Int: Ring {
    
    static var identity: Int { return 0 }
    static var cardinality: Cardinality { return .init(type: .uncountable) }
    
    func inverse(_ element: Int) -> Int {
        return -element
    }
    
    static var isCommutative: Bool {
        return true
    }
    
    func combinesWith(_ other: Int) -> Int {
        return self + other
    }
    
    static func combine(_ element1: Int, _ element2: Int) -> Int {
        return element1 + element2
    }
    
}

extension Complex: Field {
   
    static var isCommutative: Bool { return true }
    static var identity: Complex { return .zero }
    var cardinality: Cardinality { return .init(type: .uncountable) }
    
    static var unity: Complex {
        return Complex(real: 1, imaginary: 0)
    }
    
    func inverse(_ element: Complex) -> Complex {
        return -element
    }
    
    static var cardinality: Cardinality {
        return .uncountable
    }
    
    func combinesWith(_ other: Complex) -> Complex {
        return self + other
    }
    
    static func combine(_ element1: Complex, _ element2: Complex) -> Complex {
        return element1 + element2
    }
}
