//
//  Complex.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

struct Complex: Equatable, CustomStringConvertible {
    
    var real: Double = 0.0
    var imaginary: Double = 0.0
    
    static var algebraicallyClosed: Bool { return true }
    
    static let zero: Complex = .init()
    static let infinity: Complex = .init(real: .infinity, imaginary: .infinity)
    static let i: Complex = .init(real: 0, imaginary: 1)
    
    // Basic arithmetic operations
    static func + (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }
    
    static func + (lhs: Complex, rhs: Double) -> Complex {
        return Complex(real: lhs.real + rhs, imaginary: lhs.imaginary)
    }
    
    static func + (lhs: Double, rhs: Complex) -> Complex {
        return rhs + lhs
    }
    
    public static func += (lhs: inout Complex, rhs: Complex) {
        lhs.real += rhs.real
        lhs.imaginary += rhs.imaginary
    }
    
    public static func += (lhs: inout Complex, rhs: Double) {
        lhs.real += rhs
    }
    
    static func - (lhs: Complex, rhs: Double) -> Complex {
        return Complex(real: lhs.real - rhs, imaginary: lhs.imaginary)
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
    
    static func * (lhs: Complex, rhs: Double) -> Complex {
        return Complex(real: lhs.real * rhs, imaginary: lhs.imaginary * rhs)
    }
    
    static func * (lhs: Double, rhs: Complex) -> Complex {
        return rhs * lhs
    }
    
    static func *= (lhs: inout Complex, rhs: Complex) {
        lhs.real = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
        lhs.imaginary = lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
    }
    
    static func / (lhs: Complex, rhs: Complex) -> Complex {
        return Complex(real: rhs.real / (rhs * rhs.conjugate).real, imaginary: -rhs.imaginary / (rhs * rhs.conjugate).real) * lhs
    }
    
    static func / (lhs: Double, rhs: Complex) -> Complex {
        return Complex(real: rhs.real / (rhs * rhs.conjugate).real, imaginary: -rhs.imaginary / (rhs * rhs.conjugate).real) * Complex(real: lhs, imaginary: 0)
    }
    
    static func / (lhs: Complex, rhs: Double) -> Complex {
        return Complex(real: lhs.real / rhs, imaginary: lhs.imaginary / rhs)
    }
    
    static func /= (lhs: inout Complex, rhs: Complex) {
        lhs = lhs / rhs
    }
    
    static func == (lhs: Complex, rhs: Complex) -> Bool {
        return lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
    }
    
    static func == (lhs: Complex, rhs: Double) -> Bool {
        return lhs.real == rhs && lhs.imaginary == 0.0
    }
    
    static func == (lhs: Double, rhs: Complex) -> Bool {
        return lhs == rhs.real && rhs.imaginary == 0.0
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
    
    
    var description: String {
        if imaginary == 0 {
            return real.description
        } else if real == 0 {
            return imaginary.description + "i"
        } else {
            if imaginary > 0 {
                return "(\(real) + \(imaginary)i)"
            } else {
                return "(\(real) - \(-imaginary)i)"
            }
        }
    }
}
