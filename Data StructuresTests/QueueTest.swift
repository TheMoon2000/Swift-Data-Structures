//
//  QueueTest.swift
//  QueueTest
//
//  Created by Jia Rui Shan on 2019/11/17.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import XCTest
@testable import Data_Structures

class QueueTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInteger() {
        let queue = Queue<Int>()
        for i in 0..<100 {
            queue.enqueue(i)
        }
        XCTAssertEqual(queue.count, 100)
        
        for i in 0..<100 {
            XCTAssertEqual(i, queue.dequeue() ?? -1)
            XCTAssertEqual(100 - i - 1, queue.count)
        }
    }
    
    func testIteration() {
        let doubleQueue = Queue<Double>()
        
        for _ in 0..<100 {
            doubleQueue.enqueue(Double.random(in: 0...100))
        }
        
        var sum = 0.0
        
        for i in doubleQueue {
            sum += i
        }
        
        // Manual iteration
        while let next = doubleQueue.dequeue() {
            sum -= next
        }
        
        XCTAssertEqual(sum, 0.0, accuracy: 0.0001)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
