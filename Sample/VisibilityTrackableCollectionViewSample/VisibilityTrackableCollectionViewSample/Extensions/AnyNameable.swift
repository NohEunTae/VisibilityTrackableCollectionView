//
//  AnyNameable.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import Foundation

protocol AnyNameable {
    static var className: String { get }
}

extension NSObject: AnyNameable {
    
    static var className: String {
        return String(describing: self)
    }
    
}
