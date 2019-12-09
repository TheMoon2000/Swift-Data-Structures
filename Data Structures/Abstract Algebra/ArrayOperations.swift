//
//  ArrayOperations.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

/*
 This file features a variety of feature enhancements (some are inspired by NumPy) and performance improvements to some of the existing array structures in Swift, making use of SIMD vector operations as well as thread-level parallelism.
 */

import Foundation


// MARK: - Double arrays
extension Array where Element == Double {
    
    static func * (lhs: Double, rhs: [Double]) -> [Double] {
        if rhs.count <= 100 {
            return rhs.map { $0 * lhs }
        } else {
            return simdDoubleScaling32(lhs: lhs, rhs: rhs)
        }
    }
    
    static func multiply(lhs: Double, rhs: [Double], vectorSize: Int = 8) -> [Double] {
        if rhs.count <= 100 {
            return rhs.map { $0 * lhs }
        } else if vectorSize == 8 {
            return simdDoubleScaling8(lhs: lhs, rhs: rhs)
        } else if vectorSize == 16 {
            return simdDoubleScaling16(lhs: lhs, rhs: rhs)
        } else {
            return simdDoubleScaling32(lhs: lhs, rhs: rhs)
        }
    }
    
    static func simdDoubleScaling16(lhs: Double, rhs: [Double]) -> [Double] {
        let cut = rhs.count / 16 * 16
        let constantVector = SIMD16<Double>(repeating: lhs)
        var new = [Double](repeating: 0.0, count: rhs.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<rhs.count {
                new[i] = lhs * rhs[i]
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 16) { rawIndex in
            group.enter()
            let index = rawIndex * 16
            let slice = SIMD16<Double>(
                rhs[index], rhs[index+1], rhs[index+2], rhs[index+3],
                rhs[index+4], rhs[index+5], rhs[index+6], rhs[index+7],
                rhs[index+8], rhs[index+9], rhs[index+10], rhs[index+11],
                rhs[index+12], rhs[index+13], rhs[index+14], rhs[index+15]
            ) * constantVector
            
            syncQueue.async {
                new[index] = slice[0]
                new[index + 1] = slice[1]
                new[index + 2] = slice[2]
                new[index + 3] = slice[3]
                new[index + 4] = slice[4]
                new[index + 5] = slice[5]
                new[index + 6] = slice[6]
                new[index + 7] = slice[7]
                new[index + 8] = slice[8]
                new[index + 9] = slice[9]
                new[index + 10] = slice[10]
                new[index + 11] = slice[11]
                new[index + 12] = slice[12]
                new[index + 13] = slice[13]
                new[index + 14] = slice[14]
                new[index + 15] = slice[15]
                group.leave()
            }
        }
        
        group.wait()
        
        return new
    }
    
    static func simdDoubleScaling32(lhs: Double, rhs: [Double]) -> [Double] {
        let cut = rhs.count / 32 * 32
        let constantVector = SIMD32<Double>(repeating: lhs)
        var new = [Double](repeating: 0.0, count: rhs.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<rhs.count {
                new[i] = lhs * rhs[i]
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let slice = SIMD32<Double>(
                rhs[index], rhs[index+1], rhs[index+2], rhs[index+3],
                rhs[index+4], rhs[index+5], rhs[index+6], rhs[index+7],
                rhs[index+8], rhs[index+9], rhs[index+10], rhs[index+11],
                rhs[index+12], rhs[index+13], rhs[index+14], rhs[index+15],
                rhs[index+16], rhs[index+17], rhs[index+18], rhs[index+19],
                rhs[index+20], rhs[index+21], rhs[index+22], rhs[index+23],
                rhs[index+24], rhs[index+25], rhs[index+26], rhs[index+27],
                rhs[index+28], rhs[index+29], rhs[index+30], rhs[index+31]
            ) * constantVector
            
            syncQueue.async {
                new[index] = slice[0]
                new[index + 1] = slice[1]
                new[index + 2] = slice[2]
                new[index + 3] = slice[3]
                new[index + 4] = slice[4]
                new[index + 5] = slice[5]
                new[index + 6] = slice[6]
                new[index + 7] = slice[7]
                new[index + 8] = slice[8]
                new[index + 9] = slice[9]
                new[index + 10] = slice[10]
                new[index + 11] = slice[11]
                new[index + 12] = slice[12]
                new[index + 13] = slice[13]
                new[index + 14] = slice[14]
                new[index + 15] = slice[15]
                new[index + 16] = slice[16]
                new[index + 17] = slice[17]
                new[index + 18] = slice[18]
                new[index + 19] = slice[19]
                new[index + 20] = slice[20]
                new[index + 21] = slice[21]
                new[index + 22] = slice[22]
                new[index + 23] = slice[23]
                new[index + 24] = slice[24]
                new[index + 25] = slice[25]
                new[index + 26] = slice[26]
                new[index + 27] = slice[27]
                new[index + 28] = slice[28]
                new[index + 29] = slice[29]
                new[index + 30] = slice[30]
                new[index + 31] = slice[31]
                group.leave()
            }
        }
        
        group.wait()
        
        return new
    }
    
    
    static func simdDoubleScaling8(lhs: Double, rhs: [Double]) -> [Double] {
        let cut = rhs.count / 8 * 8
        let constantVector = SIMD8<Double>(repeating: lhs)
        var new = [Double](repeating: 0.0, count: rhs.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<rhs.count {
                new[i] = lhs * rhs[i]
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 8) { rawIndex in
            group.enter()
            let index = rawIndex * 8
            let slice = SIMD8<Double>(rhs[index], rhs[index+1], rhs[index+2], rhs[index+3], rhs[index+4], rhs[index+5], rhs[index+6], rhs[index+7]) * constantVector
            
            syncQueue.async {
                new[index] = slice[0]
                new[index + 1] = slice[1]
                new[index + 2] = slice[2]
                new[index + 3] = slice[3]
                new[index + 4] = slice[4]
                new[index + 5] = slice[5]
                new[index + 6] = slice[6]
                new[index + 7] = slice[7]
                group.leave()
            }
        }
        
        group.wait()
        
        return new
    }
    
    static func * (lhs: [Double], rhs: Double) -> [Double] {
        return rhs * lhs
    }
    
    var sum: Double {
        var sumVector = SIMD32<Double>()
        var tailSum = 0.0
        
        let cut = self.count / 32 * 32
        
        let syncQueue = DispatchQueue(label: "add")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<self.count {
                tailSum += self[i]
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let slice = SIMD32<Double>(
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
                sumVector += slice
                group.leave()
            }
        }
        
        group.wait()
        
        return sumVector.sum() + tailSum
    }
    
    var mean: Double {
        return sum / Double(count)
    }
    
    var variance: Double {
        
        let sampleSum = mean
        
        var sumVector = SIMD32<Double>()
        var tailSum = 0.0
        
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
            let value = SIMD32<Double>(
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
                sumVector += value * value
                group.leave()
            }
        }
        
        group.wait()
        
        return (sumVector.sum() + tailSum) / Double(count) - sampleSum * sampleSum
    }
    
    var std: Double {
        return sqrt(variance)
    }
}
