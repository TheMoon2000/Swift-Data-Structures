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
    
    static func + (lhs: Double, rhs: [Double]) -> [Double] {
        if rhs.count <= 100 {
            return rhs.map { $0 + lhs }
        } else {
            let C = SIMD32<Double>(repeating: lhs)
            return transform32(rhs, { $0 + C }, tailTransform: { $0 + lhs })
        }
    }
    
    static func + (lhs: [Double], rhs: Double) -> [Double] {
        return rhs + lhs
    }
    
    static func += (lhs: inout [Double], rhs: Double) {
        if lhs.count <= 100 {
            lhs = lhs.map { $0 + rhs }
        } else {
            let C = SIMD32<Double>(repeating: rhs)
            lhs = transform32(lhs, { $0 + C }, tailTransform: { $0 + rhs })
        }
    }
    
    static func * (lhs: Double, rhs: [Double]) -> [Double] {
        if rhs.count <= 100 {
            return rhs.map { $0 * lhs }
        } else {
            let C = SIMD32<Double>(repeating: lhs)
            return transform32(rhs, { $0 * C }, tailTransform: { $0 * lhs })
        }
    }
    
    static func * (lhs: [Double], rhs: Double) -> [Double] {
        return rhs * lhs
    }
    
    static func *= (lhs: inout [Double], rhs: Double) {
        if lhs.count <= 100 {
            lhs = lhs.map { $0 * rhs }
        } else {
            let C = SIMD32<Double>(repeating: rhs)
            lhs = transform32(lhs, { $0 * C }, tailTransform: { $0 * rhs })
        }
    }
    
    static func transform16(_ array: [Double], _ transformation: ((SIMD16<Double>) -> SIMD16<Double>), tailTransform: @escaping ((Double) -> (Double))) -> [Double] {
        let cut = array.count / 16 * 16

        var new = [Double](repeating: 0.0, count: array.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<array.count {
                new[i] = tailTransform(array[i])
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 16) { rawIndex in
            group.enter()
            let index = rawIndex * 16
            let slice = SIMD16<Double>(
                array[index], array[index+1], array[index+2], array[index+3],
                array[index+4], array[index+5], array[index+6], array[index+7],
                array[index+8], array[index+9], array[index+10], array[index+11],
                array[index+12], array[index+13], array[index+14], array[index+15]
            )
            
            let value = transformation(slice)
            
            syncQueue.async {
                new[index] = slice[0]
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
        
        group.wait()
        
        return new
    }
    
    // Apply a function to each element of a double array.
    static func transform32(_ array: [Double], _ transformation: ((SIMD32<Double>) -> SIMD32<Double>), tailTransform: @escaping ((Double) -> (Double))) -> [Double] {
        let cut = array.count / 32 * 32
        var new = [Double](repeating: 0.0, count: array.count)
        
        let syncQueue = DispatchQueue(label: "sync")
        let group = DispatchGroup()
        
        syncQueue.async {
            group.enter()
            for i in cut..<array.count {
                new[i] = tailTransform(array[i])
            }
            group.leave()
        }
        
        DispatchQueue.concurrentPerform(iterations: cut / 32) { rawIndex in
            group.enter()
            let index = rawIndex * 32
            let slice = SIMD32<Double>(
                array[index], array[index+1], array[index+2], array[index+3],
                array[index+4], array[index+5], array[index+6], array[index+7],
                array[index+8], array[index+9], array[index+10], array[index+11],
                array[index+12], array[index+13], array[index+14], array[index+15],
                array[index+16], array[index+17], array[index+18], array[index+19],
                array[index+20], array[index+21], array[index+22], array[index+23],
                array[index+24], array[index+25], array[index+26], array[index+27],
                array[index+28], array[index+29], array[index+30], array[index+31]
            )
            
            let value = transformation(slice)
            
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
