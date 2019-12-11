//
//  MinHeap.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/10.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol PriorityQueue: Sequence {
    
    func add(_ item: Element, priority: Double)
    var smallest: Element? { get }
    func changePriority(_ item: Element, priority: Double)
}

struct MinHeap<Element: Hashable> {
    
    private class Node {
        var value: Element
        var priority: Double
        var index: Int
        
        init(value: Element, index: Int, priority: Double) {
            self.value = value
            self.index = index
            self.priority = priority
        }
    }
    
    private var heapItems = [Node]()
    private var priorities = [Element: Double]()
    
    var count: Int {
        return heapItems.count
    }
    
    mutating func add(_ item: Element, priority: Double) {
        if priorities[item] != nil {
            changePriority(item, priority: priority)
        } else {
            let node = Node(value: item, index: count, priority: priority)
            self.heapItems.append(node)
            self.priorities[item] = priority
            swimUp(count - 1)
        }
    }
    
    var smallest: Element? {
        return heapItems.first?.value
    }
    
    
    func changePriority(_ item: Element, priority: Double) {
        
    }
    
    // Private
    
    /** Returns the index of the first child of the node at the given index */
    private func firstChild(_ current: Int) -> Int {
        return current * 2 + 1;
    }

    /** Returns the index of the second child of the node at the given index */
    private func secondChild(_ current: Int) -> Int {
        return current * 2 + 2;
    }

    /** Returns the index of the parent */
    private func parent(_ index: Int) -> Int {
        return (index - 1) / 2;
    }
    
    private mutating func swap(_ index1: Int, _ index2: Int) {
        let node1 = heapItems[index1], node2 = heapItems[index2]
        node1.index = index2
        node2.index = index1
        heapItems[index1] = node2
        heapItems[index2] = node1
    }
    
    @discardableResult
    private mutating func swimUp(_ index: Int) -> Int {
        if index == 0 { return 0 }
        if heapItems[index].priority >= heapItems[parent(index)].priority {
            return index;
        } else {
            swap(index, parent(index))
            return swimUp(parent(index))
        }
    }
    
    private func swimDown(_ index: Int) {
        
    }
}
