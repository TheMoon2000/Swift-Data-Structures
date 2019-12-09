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
    
    init(real: Double, imaginary: Double) {
        self.real = real
        self.imaginary = imaginary
    }
    
    static let zero: Complex = .init(real: 0, imaginary: 0)
    static let infinity: Complex = .init(real: .infinity, imaginary: .infinity)
    static let i: Complex = .init(real: 0, imaginary: 1)
    
    
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

extension Complex: AdditiveArithmetic {
    
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
       
       public static func -= (lhs: inout Complex, rhs: Double) {
           lhs.real -= rhs
       }
}

extension Complex: SignedNumeric {
    
    typealias IntegerLiteralType = Double
    
    init(integerLiteral value: Double) {
        real = Double(value)
    }
    
    
    init?<T>(exactly source: T) where T : BinaryInteger {
        real = Double(source)
    }

}

extension Complex: Strideable {
    typealias Stride = Complex

    func advanced(by n: Complex.Stride) -> Complex {
        return self + n
    }
    
    func distance(to other: Complex) -> Complex.Stride {
        return (other - self)
    }
}

extension Complex: Hashable {
    func hasher(into: inout Hasher) {
        into.combine(real)
        into.combine(imaginary)
    }
}
