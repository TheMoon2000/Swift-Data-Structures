//
//  ComplexTest.swift
//  Data StructuresTests
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import XCTest
@testable import Data_Structures

class ComplexTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddition() {
        let c1 = Complex(real: 1, imaginary: 1)
        let c2 = Complex(real: 1, imaginary: -1)
        let c3 = Complex(real: 2.5, imaginary: -1.5)
        
        XCTAssertNotEqual(c1, c2)
        XCTAssertEqual(c1 + c1, Complex(real: 2, imaginary: 2))
        XCTAssertEqual(c1 + c2, Complex(real: 2, imaginary: 0))
        XCTAssertEqual(c3 - c2, Complex(real: 1.5, imaginary: -0.5))
    }
    
    func testMultiplication() {
        let c1 = Complex(real: 1, imaginary: 1)
        let c2 = Complex(real: 1, imaginary: -1)
        let c3 = Complex(real: 1.25, imaginary: -0.75)
        
        XCTAssertEqual(c1.abs, c2.abs)
        XCTAssertEqual(c1 * c1, 2.0 * .i)
        XCTAssertTrue(c1 * c2 == 2.0)
        XCTAssertEqual(c3.abs, sqrt((c3 * c3.conjugate).real))
        XCTAssertEqual(c1 / c2, Complex(real: 0, imaginary: 1))
        print(1 / c1, c2 / 2, c3 + 4, .i * .i, 2.0 * .i)
    }

}
