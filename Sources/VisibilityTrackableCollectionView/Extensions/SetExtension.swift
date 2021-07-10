//
//  SetExtension.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//

import Foundation

extension Set {
    
    @discardableResult mutating func insert(_ newMembers: [Set.Element]) -> [(inserted: Bool, memberAfterInsert: Set.Element)] {
        newMembers.map { insert($0) }
    }
    
}
