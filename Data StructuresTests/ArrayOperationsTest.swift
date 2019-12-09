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
    
    func testSimple() {
        let A: [Double] = [0.3, -2.5, 4.0, 1.2]
        print(A * 2, A + 2)
        print(A.sum, A.mean, A.variance, A.std)
    }

    func testDoubleScalarMultiplication() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let constant = 2.3
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0 * constant }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map scaling with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant * randomDoubles
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant scaling (32) with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
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
