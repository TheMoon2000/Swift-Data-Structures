//
//  Group.swift
//  Data Structures
//
//  Created by Jia Rui Shan on 2019/12/8.
//  Copyright © 2019 Calpha Dev. All rights reserved.
//

import Foundation

protocol Group: Monoid {
    func inverse(_ element: Self) -> Self
}
