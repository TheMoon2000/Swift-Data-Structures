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
        print("A x 2 = \(A * 2); A + 2 = \(A + 2), A / 2 = \(A / 2), A - 2 = \(A - 2)")
        print("A.sum = \(A.sum()); A.mean = \(A.mean), A.variance = \(A.variance), A.std = \(A.std)")
        print("A.abs = \(A.abs); A.sqrt = \(A.squareRoot)")
        print(A.diff())
        
        // Comparisons
        print("A > 0?: \(A > 0); A <= 1.2?: \(A <= 1.2); A == 4.0: \(A == 4.0)")
        print("A > [0.0]: \(A > [0.0])")
        print([0.0, -3.0, 5.0, 2.0] >= A)
        
        // Vector arithmetics:
        let B = [1.0, 2.0, 3.0, 4.0]
        let C = [4.0, 2.0]
        print("A • B: \(A * B), A + B: \(A ++ B), A - B: \(A - B)")
        print("A + C: \(A ++ C), A - C: \(A - C)")
        print("A * C: \(A * C), A / C: \(A / C)")
        
        // Unaligned vector arithmetics
        let X = [7.875, 0.3, -0.4]
        print("A+X = \(A ++ X); A-X = \(A - X), X-A= \(X - A), X·A = \(X * A)")
        
        // Integers
        let I = [-3, 5, 9, -2, 17]
        print("I x 2: \(I * 2), I + 2: \(I + 2), I / 2: \(I / 2), I - 2: \(I - 2)")
        print("I << 2: \(I << 2), I >> 2: \(I >> 2)")
        print("I.diff(): \(I.diff())")
    }
    
    func testIntScalarAddition() {
        let randomInts = (0..<(1 << 20)).map { _ in Int.random(in: -100...100) }
        let constant = 10
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Int]()
        randomInts.forEach { vanillaResult.append(constant + $0) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant addition with \(randomInts.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomInts.map { $0 + constant }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant addition with \(randomInts.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant + randomInts
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant addition with \(randomInts.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }
    
    func testIntScalarSubtraction() {
        
    }
    
    func testDoubleScalarAddition() {
        let randomDoubles = (0..<(1 << 12)).map { _ in Double.random(in: -100...100) }
        let constant = 12.6
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        randomDoubles.forEach { vanillaResult.append(constant + $0) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant addition with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0 + constant }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant addition with \(randomDoubles.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant + randomDoubles
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant addition with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleScalarSubtraction1() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let constant = 9.4
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        randomDoubles.forEach { vanillaResult.append($0 - constant) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant subtraction with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0 - constant }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant subtraction with \(randomDoubles.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles - constant
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant subtraction with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleScalarSubtraction() {
        let randomDoubles = (0..<(1 << 10)).map { _ in Double.random(in: -100...100) }
        
        let constant = 3.5
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        randomDoubles.forEach { vanillaResult.append(constant - $0) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant subtraction with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0 - constant }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant subtraction with \(randomDoubles.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant - randomDoubles
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant subtraction with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleScalarSubtraction2() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let constant = 5.5
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        randomDoubles.forEach { vanillaResult.append(constant - $0) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant subtraction with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { constant - $0 }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant subtraction with \(randomDoubles.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant - randomDoubles
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant subtraction with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }

    func testDoubleScalarMultiplication() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let constant = 2.3
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        randomDoubles.forEach { vanillaResult.append(constant * $0) }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop constant scaling with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0 * constant }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        print("Swift map() constant scaling with \(randomDoubles.count) items: \(mapEnd - mapStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = constant * randomDoubles
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD constant scaling with \(randomDoubles.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleVectorAddition() {
        let randomDoubles1 = (0..<(1 << 23)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 23)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double](repeating: 0.0, count: randomDoubles1.count)
        
        for i in 0..<randomDoubles1.count {
            vanillaResult[i] = randomDoubles1[i] + randomDoubles2[i]
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop array addition with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 ++ randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD array addition with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testUnalignedDoubleVectorAddition() {
        let randomDoubles1 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        let longer = randomDoubles1.count > randomDoubles2.count ? randomDoubles1 : randomDoubles2
        
        for i in 0..<min(randomDoubles1.count, randomDoubles2.count) {
            vanillaResult.append(randomDoubles1[i] + randomDoubles2[i])
        }
        
        for i in min(randomDoubles1.count, randomDoubles2.count)..<longer.count {
            vanillaResult.append(longer[i])
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop array addition with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 ++ randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD array addition with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testDoubleVectorSubtraction() {
        let randomDoubles1 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        
        for i in 0..<randomDoubles1.count {
            vanillaResult.append(randomDoubles1[i] - randomDoubles2[i])
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop array subtraction with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 - randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD array subtraction with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testUnalignedDoubleVectorSubtraction() {
        let randomDoubles1 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        let longer = randomDoubles1.count > randomDoubles2.count ? randomDoubles1 : randomDoubles2
        
        for i in 0..<min(randomDoubles1.count, randomDoubles2.count) {
            vanillaResult.append(randomDoubles1[i] - randomDoubles2[i])
        }
        
        
        for i in min(randomDoubles1.count, randomDoubles2.count)..<longer.count {
            if randomDoubles1.count > randomDoubles2.count {
                vanillaResult.append(randomDoubles1[i])
            } else {
                vanillaResult.append(-randomDoubles2[i])
            }
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop unaligned double subtraction with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 - randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD unaligned double subtraction with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
        XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testAlignedDoubleVectorMultiplication() {
        let randomDoubles1 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        
        for i in 0..<randomDoubles1.count {
            vanillaResult.append(randomDoubles1[i] * randomDoubles2[i])
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop array subtraction with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 * randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD array subtraction with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
         XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testUnalignedDoubleVectorMultiplication() {
        let randomDoubles1 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        let randomDoubles2 = (0..<(1 << 20)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        let longer = randomDoubles1.count > randomDoubles2.count ? randomDoubles1 : randomDoubles2
        
        for i in 0..<min(randomDoubles1.count, randomDoubles2.count) {
            vanillaResult.append(randomDoubles1[i] * randomDoubles2[i])
        }
        
        for _ in min(randomDoubles1.count, randomDoubles2.count)..<longer.count {
            vanillaResult.append(0)
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("For loop array addition with \(randomDoubles1.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles1 • randomDoubles2
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD array addition with \(randomDoubles1.count) items: \(simdEnd - simdStart)s")
                
        XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testDoubleAbs() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...10) }
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { abs($0) }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        
        print("Swift map() abs with \(randomDoubles.count) items: \(mapEnd - mapStart)")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles.abs
        let simdEnd = Date.timeIntervalSinceReferenceDate
        
        print("SIMD abs() with \(randomDoubles.count) items: \(simdEnd - simdStart)")

        XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleSqrt() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: 0...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        
        for i in 0..<randomDoubles.count {
            vanillaResult.append(sqrt(randomDoubles[i]))
        }
        
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla sqrt() with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { sqrt($0) }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        
        print("Swift sqrt() with \(randomDoubles.count) items: \(mapEnd - mapStart)")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles.sqrt
        let simdEnd = Date.timeIntervalSinceReferenceDate
        
        print("SIMD sqrt() with \(randomDoubles.count) items: \(simdEnd - simdStart)")

        XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleArrayRound() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -100...10) }
        
        let mapStart = Date.timeIntervalSinceReferenceDate
        let mapResult = randomDoubles.map { $0.rounded(.toNearestOrEven) }
        let mapEnd = Date.timeIntervalSinceReferenceDate
        
        print("Swift map() floating point rounding with \(randomDoubles.count) items: \(mapEnd - mapStart)")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles.rounded
        let simdEnd = Date.timeIntervalSinceReferenceDate
        
        print("SIMD floating point rounding with \(randomDoubles.count) items: \(simdEnd - simdStart)")

        XCTAssertEqual(mapResult, simdResult)
    }
    
    func testDoubleSum() {
        let randomDoubles = (0..<(1 << 24)).map { _ in Double.random(in: -100...100) }
        
        let reduceStart = Date.timeIntervalSinceReferenceDate
        let manualSum: Double = randomDoubles.reduce(0.0, { result, next in
            return result + next
        })
        let reduceEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla reduce sum computation: \(reduceEnd - reduceStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdSum = randomDoubles.sum()
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD sum computation: \(simdEnd - simdStart)s")
        /*
        self.measure {
            randomDoubles.sum()
        }*/
        
        XCTAssertEqual(manualSum, simdSum, accuracy: 0.0001)
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
        
        let simdVariance = randomDoubles.variance
        
        self.measure { randomDoubles.variance }
        
        XCTAssertEqual(manualVariance, simdVariance, accuracy: 0.99999)
    }
    
    func testFloatArrayVariance() {
        let randomFloats = (0..<(1 << 20)).map { _ in Float.random(in: -10...10) }
        
        let reduceStart = Date.timeIntervalSinceReferenceDate
        let sum: Float = randomFloats.reduce(0, { result, next in
            return result + next
        }) / Float(randomFloats.count)
        let manualVariance: Float = randomFloats.reduce(0, { result, next in
            return result + next * next
        }) / Float(randomFloats.count) - sum * sum
        let reduceEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla variance: \(reduceEnd - reduceStart)s")
        
        let simdVariance = randomFloats.variance
        
        print("SIMD Measurement:")
        self.measure { randomFloats.variance }
        
        XCTAssertEqual(manualVariance, simdVariance, accuracy: 0.999)
    }

    func testDoubleDiff() {
        let randomDoubles = (0..<(1 << 20 + 31)).map { _ in Double.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Double]()
        for i in 0..<(randomDoubles.count - 1) {
            vanillaResult.append(randomDoubles[i + 1] - randomDoubles[i])
        }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla difference: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomDoubles.diff()
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD reduce: \(simdEnd - simdStart)")
        
        XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testFloatDiff() {
        let randomFloats = (0..<(1 << 20 + 31)).map { _ in Float.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Float]()
        for i in 0..<(randomFloats.count - 1) {
            vanillaResult.append(randomFloats[i + 1] - randomFloats[i])
        }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla difference: \(vanillaEnd - vanillaStart)s")
        
        let simdStart = Date.timeIntervalSinceReferenceDate
        let simdResult = randomFloats.diff()
        let simdEnd = Date.timeIntervalSinceReferenceDate
        print("SIMD reduce: \(simdEnd - simdStart)")
        
        self.measure { randomFloats.diff() }
        
        XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testIntDiff() {
        let randomInts = (0..<(1 << 20)).map { _ in Int.random(in: -100...100) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        var vanillaResult = [Int]()
        for i in 0..<(randomInts.count - 1) {
            vanillaResult.append(randomInts[i + 1] - randomInts[i])
        }
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla difference with \(randomInts.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdResult = randomInts.diff()
        
        print("SIMD Measurement with \(randomInts.count) items: ")
        self.measure {
            let _ = randomInts.diff()
        }
        
        XCTAssertEqual(vanillaResult, simdResult)
    }
    
    func testDoubleProduct() {
        let randomDoubles = (0..<(1 << 20)).map { _ in Double.random(in: -2...3) }
        
        let vanillaStart = Date.timeIntervalSinceReferenceDate
        let vanillaResult = randomDoubles.reduce(1.0, { result, next in
            return result * next
        })
        let vanillaEnd = Date.timeIntervalSinceReferenceDate
        print("Vanilla difference with \(randomDoubles.count) items: \(vanillaEnd - vanillaStart)s")
        
        let simdResult = randomDoubles.prod()
        
        print("SIMD Measurement for \(randomDoubles.count) items: ")
        self.measure {
            let _ = randomDoubles.prod()
        }
        
        XCTAssertEqual(vanillaResult, simdResult, accuracy: 0.001)
    }
    
    func testDoubleMedian() {
        XCTAssertEqual(2.5, [1.0, 2.0, 3.0, 4.0].median)
        XCTAssertEqual(1.0, [1.0].median)
        XCTAssertEqual(0.0, [Double]().median)
        XCTAssertEqual(0.0, [-1.0, 0.0, 1.0].median)
    }
}
