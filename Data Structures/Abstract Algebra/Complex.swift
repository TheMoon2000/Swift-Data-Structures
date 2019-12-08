//
//  Complex.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

struct Complex: Equatable {
    
    var real: Double = 0.0
    var imaginary: Double = 0.0
    
    static let zero: Complex = .init()
    static let infinity: Complex = .init(real: .infinity, imaginary: .infinity)
    
    // Basic arithmetic operations
    static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    public static func += (lhs: inout Complex, rhs: Complex) {
        lhs.real += rhs.real
        lhs.imaginary += rhs.imaginary
    }
    
    static func - (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }
    
    public static func -= (lhs: inout Complex, rhs: Complex) {
        lhs.real -= rhs.real
        lhs.imaginary -= rhs.imaginary
    }
    
    static func * (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real * rhs.real - lhs.imaginary * rhs.imaginary, imaginary: lhs.real * rhs.imaginary + lhs.imaginary * rhs.real)
    }
    
    static func *= (lhs: inout Complex, rhs: Complex) {
        lhs.real = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
        lhs.imaginary = lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
    }
    
    static func / (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: rhs.real / (rhs * rhs.conjugate).real, imaginary: -rhs.imaginary / (rhs * rhs.conjugate).real) * lhs
    }
    
    static func /= (lhs: inout Complex, rhs: Complex) {
        lhs = lhs / rhs
    }
    
    
    static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
    }
    
    prefix static func - (operand: Complex) -> Complex {
        return Complex(real: -operand.real, imaginary: -operand.imaginary)
    }
    
    var abs: Double {
        return sqrt(real * real + imaginary * imaginary)
    }
    
    var conjugate: Complex {
        return Complex(real: self.real, imaginary: -self.imaginary)
    }
    
    var magnitude: Double { return abs }
}
