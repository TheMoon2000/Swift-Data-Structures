//
//  IntegerArrayOperations.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

infix operator ++
infix operator •

extension Array where Element: SIMDScalar & FixedWidthInteger & SignedInteger {
    
    enum IntegerArithmeticType: Int {
        case addition, subtraction, multiplication, division, leftShift, rightShift
    }

    static func + (lhs: Element, rhs: [Element]) -> [Element] {
        if rhs.count < cutoff {
            return rhs.map { $0 + lhs }
        } else {
            return transform32(rhs, type: .addition, constant: lhs)
        }
    }
    
    static func + (lhs: [Element], rhs: Element) -> [Element] {
        return rhs + lhs
    }
    
    static func += (lhs: inout [Element], rhs: Element) {
        lhs = rhs + lhs
    }
    
    static func * (lhs: Element, rhs: [Element]) -> [Element] {
        if rhs.count < cutoff {
            return rhs.map { $0 * lhs }
        } else {
            return transform16(rhs, type: .multiplication, constant: lhs)
        }
    }
    
    static func * (lhs: [Element], rhs: Element) -> [Element] {
        return rhs * lhs
    }
    
    static func *= (lhs: inout [Element], rhs: Element) {
        lhs = rhs + lhs
    }
    
    static prefix func - (lhs: [Element]) -> [Element] {
        return -1 * lhs
    }
    
    static func - (lhs: [Element], rhs: [Element]) -> [Element] {
        return transform32(lhs, rhs, type: .subtraction)
    }

    static func - (lhs: Element, rhs: [Element]) -> [Element] {
        return transform32(rhs, type: .subtraction, constant: lhs)
    }
    
    static func - (lhs: [Element], rhs: Element) -> [Element] {
        return lhs + -rhs
    }
    
    static func -= (lhs: inout [Element], rhs: Element) {
        lhs = lhs - rhs
    }
    
    static func << (lhs: [Element], rhs: Element) -> [Element] {
        return transform32(lhs, type: .leftShift, constant: rhs)
    }
    
    static func <<= (lhs: inout [Element], rhs: Element) {
        lhs = lhs << rhs
    }
    
    static func >> (lhs: [Element], rhs: Element) -> [Element] {
        return transform32(lhs, type: .rightShift, constant: rhs)
    }
    
    static func >>= (lhs: inout [Element], rhs: Element) {
        lhs = lhs >> rhs
    }
    
    /// Divide every element in the array by the given divisor. Please make sure that the divisor is nonzero.
    static func / (lhs: [Element], rhs: Element) -> [Element] {
        if lhs.count < cutoff {
            return lhs.map { $0 / rhs }
        } else {
            return transform16(lhs, type: .division, constant: rhs)
        }
    }
    
    static func /= (lhs: inout [Element], rhs: Element) {
        lhs = lhs / rhs
    }
    
    /// Element-wise addition of two `Element` arrays.
    static func ++ (lhs: [Element], rhs: [Element]) -> [Element] {
        return transform32(lhs, rhs, type: .addition)
    }
    
    /// Element-wise multiplication of two `Element` arrays (dot product). If the lengths of the arrays are unequal, the shorter array will be treated as having trailing zeroes.
    static func • (lhs: [Element], rhs: [Element]) -> [Element] {
        return transform32(lhs, rhs, type: .multiplication)
    }
    
    /// Multiply two vectors component-wise (dot product). Alias of '•'.
    static func * (lhs: [Element], rhs: [Element]) -> [Element] {
        return lhs • rhs
    }
    
    static func < (lhs: [Element], rhs: [Element]) -> [Bool] {
        return compare32(lhs, rhs, type: .lessThan)
    }
    
    static func < (lhs: [Element], rhs: Element) -> [Bool] {
        return compare32I(lhs, rhs, type: .lessThan)
    }
    
    static func <= (lhs: [Element], rhs: [Element]) -> [Bool] {
        return compare32(lhs, rhs, type: .lessThanOrEqualTo)
    }
    
    static func <= (lhs: [Element], rhs: Element) -> [Bool] {
        return compare32I(lhs, rhs, type: .lessThanOrEqualTo)
    }
    
    static func > (lhs: [Element], rhs: [Element]) -> [Bool] {
        return compare32(lhs, rhs, type: .greaterThan)
    }
    
    static func > (lhs: [Element], rhs: Element) -> [Bool] {
        return compare32I(lhs, rhs, type: .greaterThan)
    }
    
    static func >= (lhs: [Element], rhs: [Element]) -> [Bool] {
        return compare32(lhs, rhs, type: .greaterThenOrEqualTo)
    }
    
    static func >= (lhs: [Element], rhs: Element) -> [Bool] {
        return compare32I(lhs, rhs, type: .greaterThenOrEqualTo)
    }
    
    static func == (lhs: [Element], rhs: Element) -> [Bool] {
        return compare32I(lhs, rhs, type: .equal)
    }
    
    /// Not used because SIMD 32 generally has better performance.
    static func transform16(_ array: [Element], type: IntegerArithmeticType, constant: Element = 0) -> [Element] {
        let cut = array.count / 16 * 16
        let C = SIMD16<Element>(repeating: constant)
        var new = Array<Element>(repeating: Element.zero, count: array.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: cut / 16) { rawIndex in
            group.enter()
            let index = rawIndex * 16
            let slice = SIMD16<Element>(
                array[index], array[index+1], array[index+2], array[index+3],
                array[index+4], array[index+5], array[index+6], array[index+7],
                array[index+8], array[index+9], array[index+10], array[index+11],
                array[index+12], array[index+13], array[index+14], array[index+15]
            )
            
            // Select the correct arithemetic operation
            let value: SIMD16<Element>
            switch type {
            case .addition:
                value = slice &+ C
            case .subtraction:
                value = C &- slice
            case .multiplication:
                value = slice &* C
            case .division:
                value = slice / C
            case .leftShift:
                value = slice &<< C
            case .rightShift:
                value = slice &>> C
            }
            
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                group.leave()
            }
        }
        
        group.enter()
        syncQueue.async {
            for i in cut..<array.count {
                switch type {
                case .addition:
                    new[i] = array[i] + constant
                case .subtraction:
                    new[i] = constant - array[i]
                case .multiplication:
                    new[i] = array[i] * constant
                case .division:
                    new[i] = array[i] / constant
                case .leftShift:
                    new[i] = array[i] << constant
                case .rightShift:
                    new[i] = array[i] >> constant
                }
            }
            group.leave()
        }
        
        group.wait()
        
        return new
    }
    
    // Apply a function to each element of a Element array.
    static func transform32(_ array: [Element], type: IntegerArithmeticType, constant: Element = Element.zero) -> [Element] {
        let cut = array.count / 32 * 32
        var new = [Element](repeating: Element.zero, count: array.count)
        let C = SIMD32<Element>(repeating: constant)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let slice = SIMD32<Element>(
                array[index], array[index+1], array[index+2], array[index+3],
                array[index+4], array[index+5], array[index+6], array[index+7],
                array[index+8], array[index+9], array[index+10], array[index+11],
                array[index+12], array[index+13], array[index+14], array[index+15],
                array[index+16], array[index+17], array[index+18], array[index+19],
                array[index+20], array[index+21], array[index+22], array[index+23],
                array[index+24], array[index+25], array[index+26], array[index+27],
                array[index+28], array[index+29], array[index+30], array[index+31]
            )
            
            // Select the correct arithemetic operation
            let value: SIMD32<Element>
            switch type {
            case .addition:
                value = slice &+ C
            case .subtraction:
                value = C &- slice
            case .multiplication:
                value = slice &* C
            case .division:
                value = slice / C
            case .leftShift:
                value = slice &<< C
            case .rightShift:
                value = slice &>> C
            }
            
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                new[index + 16] = value[16]
                new[index + 17] = value[17]
                new[index + 18] = value[18]
                new[index + 19] = value[19]
                new[index + 20] = value[20]
                new[index + 21] = value[21]
                new[index + 22] = value[22]
                new[index + 23] = value[23]
                new[index + 24] = value[24]
                new[index + 25] = value[25]
                new[index + 26] = value[26]
                new[index + 27] = value[27]
                new[index + 28] = value[28]
                new[index + 29] = value[29]
                new[index + 30] = value[30]
                new[index + 31] = value[31]
                group.leave()
            }
        }
        
        group.enter()
        syncQueue.async {
            for i in cut..<array.count {
                switch type {
                case .addition:
                    new[i] = array[i] + constant
                case .subtraction:
                    new[i] = constant - array[i]
                case .multiplication:
                    new[i] = array[i] * constant
                case .division:
                    new[i] = array[i] / constant
                case .leftShift:
                    new[i] = array[i] << constant
                case .rightShift:
                    new[i] = array[i] >> constant
                }
            }
            group.leave()
        }
        
        group.wait()
        
        return new
    }
    
    // Apply a binary operation on two arrays.
    static func transform32(_ array1: [Element], _ array2: [Element], type: VectorArithmeticType) -> [Element] {
                
        let cut = Swift.min(array1.count, array2.count) / 32 * 32
        var new = [Element](repeating: Element.zero, count: Swift.max(array1.count, array2.count))
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        group.enter()
        syncQueue.async {
            for i in cut..<Swift.min(array1.count, array2.count) {
                switch type {
                case .addition:
                    new[i] = array1[i] + array2[i]
                case .subtraction:
                    new[i] = array1[i] - array2[i]
                case .multiplication:
                    new[i] = array1[i] * array2[i]
                case .division:
                    new[i] = array1[i] / array2[i]
                }
            }
            
            for i in Swift.min(array1.count, array2.count)..<Swift.max(array1.count, array2.count) {
                switch type {
                case .addition:
                    new[i] = array1.count > array2.count ? array1[i] : array2[i]
                default:
                    break
                }
            }
                        
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let vec1 = SIMD32<Element>(
                array1[index], array1[index+1], array1[index+2], array1[index+3],
                array1[index+4], array1[index+5], array1[index+6], array1[index+7],
                array1[index+8], array1[index+9], array1[index+10], array1[index+11],
                array1[index+12], array1[index+13], array1[index+14], array1[index+15],
                array1[index+16], array1[index+17], array1[index+18], array1[index+19],
                array1[index+20], array1[index+21], array1[index+22], array1[index+23],
                array1[index+24], array1[index+25], array1[index+26], array1[index+27],
                array1[index+28], array1[index+29], array1[index+30], array1[index+31]
            )
            let vec2 = SIMD32<Element>(
                array2[index], array2[index+1], array2[index+2], array2[index+3],
                array2[index+4], array2[index+5], array2[index+6], array2[index+7],
                array2[index+8], array2[index+9], array2[index+10], array2[index+11],
                array2[index+12], array2[index+13], array2[index+14], array2[index+15],
                array2[index+16], array2[index+17], array2[index+18], array2[index+19],
                array2[index+20], array2[index+21], array2[index+22], array2[index+23],
                array2[index+24], array2[index+25], array2[index+26], array2[index+27],
                array2[index+28], array2[index+29], array2[index+30], array2[index+31]
            )
            
            // Select the correct arithemetic operation
            let value: SIMD32<Element>
            switch type {
            case .addition:
                value = vec1 &+ vec2
            case .subtraction:
                value = vec1 &- vec2
            case .multiplication:
                value = vec1 &* vec2
            case .division:
                value = vec1 / vec2
            }
            
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                new[index + 16] = value[16]
                new[index + 17] = value[17]
                new[index + 18] = value[18]
                new[index + 19] = value[19]
                new[index + 20] = value[20]
                new[index + 21] = value[21]
                new[index + 22] = value[22]
                new[index + 23] = value[23]
                new[index + 24] = value[24]
                new[index + 25] = value[25]
                new[index + 26] = value[26]
                new[index + 27] = value[27]
                new[index + 28] = value[28]
                new[index + 29] = value[29]
                new[index + 30] = value[30]
                new[index + 31] = value[31]
                group.leave()
            }
        }
        
        group.wait()
                
        return new
    }
    
    // Apply a binary operation on two arrays.
    static func compare32(_ array1: [Element], _ array2: [Element], type: ComparisonType) -> [Bool] {
                
        let cut = Swift.min(array1.count, array2.count) / 32 * 32
        var new = [Bool](repeating: false, count: Swift.max(array1.count, array2.count))
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        group.enter()
        syncQueue.async {
            for i in cut..<Swift.min(array1.count, array2.count) {
                switch type {
                case .lessThan:
                    new[i] = array1[i] < array2[i]
                case .lessThanOrEqualTo:
                    new[i] = array1[i] <= array2[i]
                case .greaterThan:
                    new[i] = array1[i] > array2[i]
                case .greaterThenOrEqualTo:
                    new[i] = array1[i] >= array2[i]
                case .equal:
                    new[i] = array1[i] == array2[i]
                }
            }
                        
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let vec1 = SIMD32<Element>(
                array1[index], array1[index+1], array1[index+2], array1[index+3],
                array1[index+4], array1[index+5], array1[index+6], array1[index+7],
                array1[index+8], array1[index+9], array1[index+10], array1[index+11],
                array1[index+12], array1[index+13], array1[index+14], array1[index+15],
                array1[index+16], array1[index+17], array1[index+18], array1[index+19],
                array1[index+20], array1[index+21], array1[index+22], array1[index+23],
                array1[index+24], array1[index+25], array1[index+26], array1[index+27],
                array1[index+28], array1[index+29], array1[index+30], array1[index+31]
            )
            let vec2 = SIMD32<Element>(
                array2[index], array2[index+1], array2[index+2], array2[index+3],
                array2[index+4], array2[index+5], array2[index+6], array2[index+7],
                array2[index+8], array2[index+9], array2[index+10], array2[index+11],
                array2[index+12], array2[index+13], array2[index+14], array2[index+15],
                array2[index+16], array2[index+17], array2[index+18], array2[index+19],
                array2[index+20], array2[index+21], array2[index+22], array2[index+23],
                array2[index+24], array2[index+25], array2[index+26], array2[index+27],
                array2[index+28], array2[index+29], array2[index+30], array2[index+31]
            )
            
            // Select the correct arithemetic operation
            let value: SIMDMask<SIMD32<Element.SIMDMaskScalar>>
            switch type {
            case .lessThan:
                value = vec1 .< vec2
            case .lessThanOrEqualTo:
                value = vec1 .<= vec2
            case .greaterThan:
                value = vec1 .> vec2
            case .greaterThenOrEqualTo:
                value = vec1 .>= vec2
            case .equal:
                value = vec1 .== vec2
            }
                        
            
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                new[index + 16] = value[16]
                new[index + 17] = value[17]
                new[index + 18] = value[18]
                new[index + 19] = value[19]
                new[index + 20] = value[20]
                new[index + 21] = value[21]
                new[index + 22] = value[22]
                new[index + 23] = value[23]
                new[index + 24] = value[24]
                new[index + 25] = value[25]
                new[index + 26] = value[26]
                new[index + 27] = value[27]
                new[index + 28] = value[28]
                new[index + 29] = value[29]
                new[index + 30] = value[30]
                new[index + 31] = value[31]
                group.leave()
            }
        }
        
        group.wait()
                
        return new
    }
    
    // Apply a binary operation on two arrays.
    static func compare32I(_ array1: [Element], _ constant: Element, type: ComparisonType) -> [Bool] {
                
        let cut = array1.count / 32 * 32
        let C = SIMD32<Element>(repeating: constant)
        var new = [Bool](repeating: false, count: array1.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        group.enter()
        syncQueue.async {
            for i in cut..<array1.count {
                switch type {
                case .lessThan:
                    new[i] = array1[i] < constant
                case .lessThanOrEqualTo:
                    new[i] = array1[i] <= constant
                case .greaterThan:
                    new[i] = array1[i] > constant
                case .greaterThenOrEqualTo:
                    new[i] = array1[i] >= constant
                case .equal:
                    new[i] = array1[i] == constant
                }
            }
                        
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let vec1 = SIMD32<Element>(
                array1[index], array1[index+1], array1[index+2], array1[index+3],
                array1[index+4], array1[index+5], array1[index+6], array1[index+7],
                array1[index+8], array1[index+9], array1[index+10], array1[index+11],
                array1[index+12], array1[index+13], array1[index+14], array1[index+15],
                array1[index+16], array1[index+17], array1[index+18], array1[index+19],
                array1[index+20], array1[index+21], array1[index+22], array1[index+23],
                array1[index+24], array1[index+25], array1[index+26], array1[index+27],
                array1[index+28], array1[index+29], array1[index+30], array1[index+31]
            )
            
            // Select the correct arithemetic operation
            let value: SIMDMask<SIMD32<Element.SIMDMaskScalar>>
            switch type {
            case .lessThan:
                value = vec1 .< C
            case .lessThanOrEqualTo:
                value = vec1 .<= C
            case .greaterThan:
                value = vec1 .> C
            case .greaterThenOrEqualTo:
                value = vec1 .>= C
            case .equal:
                value = vec1 .== C
            }
                        
            
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                new[index + 16] = value[16]
                new[index + 17] = value[17]
                new[index + 18] = value[18]
                new[index + 19] = value[19]
                new[index + 20] = value[20]
                new[index + 21] = value[21]
                new[index + 22] = value[22]
                new[index + 23] = value[23]
                new[index + 24] = value[24]
                new[index + 25] = value[25]
                new[index + 26] = value[26]
                new[index + 27] = value[27]
                new[index + 28] = value[28]
                new[index + 29] = value[29]
                new[index + 30] = value[30]
                new[index + 31] = value[31]
                group.leave()
            }
        }
        
        group.wait()
                
        return new
    }
    
    var sum: Element {
        var sumVector = SIMD32<Element>()
        var tailSum = Element.zero
        
        let cut = self.count / 32 * 32
        
        let syncQueue = DispatchQueue(label: "add")
        let group = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let slice = SIMD32<Element>(
                self[index], self[index+1], self[index+2], self[index+3],
                self[index+4], self[index+5], self[index+6], self[index+7],
                self[index+8], self[index+9], self[index+10], self[index+11],
                self[index+12], self[index+13], self[index+14], self[index+15],
                self[index+16], self[index+17], self[index+18], self[index+19],
                self[index+20], self[index+21], self[index+22], self[index+23],
                self[index+24], self[index+25], self[index+26], self[index+27],
                self[index+28], self[index+29], self[index+30], self[index+31]
            )
            
            syncQueue.async {
                sumVector &+= slice
                group.leave()
            }
        }
        
        group.enter()
        syncQueue.async {
            for i in cut..<self.count {
                tailSum += self[i]
            }
            group.leave()
        }
        
        group.wait()
        
        return sumVector.wrappedSum() + tailSum
    }
    
    var mean: Double {
        return count == 0 ? 0 : Double(sum) / Double(count)
    }
    
    var variance: Double {
        
        if count == 0 { return 0 }
        
        let sampleSum = mean
        
        var sumVector = SIMD32<Element>()
        var tailSum = Element.zero
        
        let cut = self.count / 32 * 32
        
        let syncQueue = DispatchQueue(label: "add")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<self.count {
                tailSum += self[i] * self[i]
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let value = SIMD32<Element>(
                self[index], self[index+1], self[index+2], self[index+3],
                self[index+4], self[index+5], self[index+6], self[index+7],
                self[index+8], self[index+9], self[index+10], self[index+11],
                self[index+12], self[index+13], self[index+14], self[index+15],
                self[index+16], self[index+17], self[index+18], self[index+19],
                self[index+20], self[index+21], self[index+22], self[index+23],
                self[index+24], self[index+25], self[index+26], self[index+27],
                self[index+28], self[index+29], self[index+30], self[index+31]
            )
            
            syncQueue.async {
                sumVector &+= value &* value
                group.leave()
            }
        }
        
        group.wait()
        
        return Double(sumVector.wrappedSum() + tailSum) / Double(count) - sampleSum * sampleSum
    }
    
    var abs: [Element] {
        return map { $0 >= Element.zero ? $0 : -$0 }
    }
    
    
    // Computes the difference between adjacent elements, and outputs the result as an array of the same type.
    
    @discardableResult
    func diff() -> [Element] {
        if count < 2 {
            return self
        }
        
        let cut = (count - 1) / 32 * 32
        var new = Array<Element>(repeating: Element.zero, count: count - 1)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let vec1 = SIMD32<Element>(
                self[index], self[index+1], self[index+2], self[index+3],
                self[index+4], self[index+5], self[index+6], self[index+7],
                self[index+8], self[index+9], self[index+10], self[index+11],
                self[index+12], self[index+13], self[index+14], self[index+15],
                self[index+16], self[index+17], self[index+18], self[index+19],
                self[index+20], self[index+21], self[index+22], self[index+23],
                self[index+24], self[index+25], self[index+26], self[index+27],
                self[index+28], self[index+29], self[index+30], self[index+31]
            )
            let vec2 = SIMD32<Element>(
                self[index+1], self[index+2], self[index+3], self[index+4],
                self[index+5], self[index+6], self[index+7], self[index+8],
                self[index+9], self[index+10], self[index+11], self[index+12],
                self[index+13], self[index+14], self[index+15], self[index+16],
                self[index+17], self[index+18], self[index+19], self[index+20],
                self[index+21], self[index+22], self[index+23], self[index+24],
                self[index+25], self[index+26], self[index+27], self[index+28],
                self[index+29], self[index+30], self[index+31], self[index+32]
            )
            
            // Select the correct arithemetic operation
            let value = vec2 &- vec1
            syncQueue.async {
                new[index] = value[0]
                new[index + 1] = value[1]
                new[index + 2] = value[2]
                new[index + 3] = value[3]
                new[index + 4] = value[4]
                new[index + 5] = value[5]
                new[index + 6] = value[6]
                new[index + 7] = value[7]
                new[index + 8] = value[8]
                new[index + 9] = value[9]
                new[index + 10] = value[10]
                new[index + 11] = value[11]
                new[index + 12] = value[12]
                new[index + 13] = value[13]
                new[index + 14] = value[14]
                new[index + 15] = value[15]
                new[index + 16] = value[16]
                new[index + 17] = value[17]
                new[index + 18] = value[18]
                new[index + 19] = value[19]
                new[index + 20] = value[20]
                new[index + 21] = value[21]
                new[index + 22] = value[22]
                new[index + 23] = value[23]
                new[index + 24] = value[24]
                new[index + 25] = value[25]
                new[index + 26] = value[26]
                new[index + 27] = value[27]
                new[index + 28] = value[28]
                new[index + 29] = value[29]
                new[index + 30] = value[30]
                new[index + 31] = value[31]
                group.leave()
            }
        }
        
        /*
        DispatchQueue.concurrentPerform(iterations: self.count - 1 - cut) { index in
            group.enter()
            let d = self[cut + index + 1] - self[cut + index]
            syncQueue.async {
                new[cut + index] = d
                group.leave()
            }
        }*/
        
        
        group.enter()
        syncQueue.async {
            for i in cut..<(self.count - 1) {
                new[i] = self[i + 1] - self[i]
            }
                        
            group.leave()
        }
        
        
        group.wait()
                
        return new
    }
    
}
