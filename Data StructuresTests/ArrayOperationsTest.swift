//
//  ArrayOperationsTest.swift
//  Data StructuresTests
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import XCTest
@testable import Data_Structures

class ArrayOperationsTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDoubleScalarMultiplicationPerformance() {
        let randomDoubles = (0..<(1 << 10)).map { _ in Double.random(in: -100...100) }
        let constant = 2.3
        let iterations = 1
        
        print("Average time of multiplying double array of size \(randomDoubles.count) by a constant factor: ")
        
        var vanillaTotal = 0.0
        for _ in 0..<iterations {
            let start = Date.timeIntervalSinceReferenceDate
            var vanillaResult = [Double]()
            for double in randomDoubles {
                vanillaResult.append(double * constant)
            }
            let end = Date.timeIntervalSinceReferenceDate
            vanillaTotal += end - start
        }
        print("Vanilla constant scaling with \(randomDoubles.count) items: \(vanillaTotal / Double(iterations))s")
        
        var simd8Total = 0.0
        for _ in 0..<iterations {
            let start = Date.timeIntervalSinceReferenceDate
            let _ = [Double].multiply(lhs: constant, rhs: randomDoubles)
            let end = Date.timeIntervalSinceReferenceDate
            simd8Total += end - start
        }
        print("SIMD constant scaling (8) with \(randomDoubles.count) items: \(simd8Total / Double(iterations))s")
        
        var simd16Total = 0.0
        for _ in 0..<iterations {
            let start = Date.timeIntervalSinceReferenceDate
            let _ = [Double].multiply(lhs: constant, rhs: randomDoubles, vectorSize: 16)
            let end = Date.timeIntervalSinceReferenceDate
            simd16Total += end - start
        }
        print("SIMD constant scaling (16) with \(randomDoubles.count) items: \(simd16Total / Double(iterations))s")
        
        var simd32Total = 0.0
        for _ in 0..<iterations {
            let start = Date.timeIntervalSinceReferenceDate
            let _ = [Double].multiply(lhs: constant, rhs: randomDoubles, vectorSize: 32)
            simd32Total += Date.timeIntervalSinceReferenceDate - start
        }
        print("SIMD constant scaling (32) with \(randomDoubles.count) items: \(simd32Total / Double(iterations))s")
        
        var mapTotal = 0.0
        for _ in 0..<iterations {
            let start = Date.timeIntervalSinceReferenceDate
            let _ = randomDoubles.map { $0 * constant }
            mapTotal += Date.timeIntervalSinceReferenceDate - start
        }
        
        print("Map constant scaling with \(randomDoubles.count) items: \(mapTotal / Double(iterations))s")
        
        // XCTAssertEqual(vanillaResult, simdResult)
        // XCTAssertEqual(vanillaResult, simd16Result)
        // XCTAssertEqual(vanillaResult, simd32Result)
    }
    
    func testDoubleSum() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let reduceStart = Date.timeIntervalSinceReferenceDate
        let manualSum: Double = randomDoubles.reduce(0, { result, next in
            return result + next
        })
        let reduceEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla reduce: \(reduceEnd - reduceStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdSum = randomDoubles.sum
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD reduce: \(simdEnd - simdStart)")
        
        XCTAssertEqual(manualSum, simdSum, accuracy: 1 / 1000000)
    }
    
    func testDoubleArrayMean() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let reduceStart = Date.timeIntervalSinceReferenceDate
        let manualMean: Double = randomDoubles.reduce(0, { result, next in
            return result + next
        }) / Double(randomDoubles.count)
        let reduceEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla reduce: \(reduceEnd - reduceStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdMean = randomDoubles.mean
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD reduce: \(simdEnd - simdStart)")
        
        XCTAssertEqual(manualMean, simdMean, accuracy: 0.99999)
    }
    
    func testDoubleArrayVariance() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let reduceStart = Date.timeIntervalSinceReferenceDate
        let sum: Double = randomDoubles.reduce(0, { result, next in
            return result + next
        }) / Double(randomDoubles.count)
        let manualVariance: Double = randomDoubles.reduce(0, { result, next in
            return result + next * next
        }) / Double(randomDoubles.count) - sum * sum
        let reduceEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla variance: \(reduceEnd - reduceStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdVariance = randomDoubles.variance
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD variance: \(simdEnd - simdStart)")
        
        XCTAssertEqual(manualVariance, simdVariance, accuracy: 0.999)
    }

}
