//
//  SectionSupplement.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//

#if os(iOS)
import UIKit

enum SectionSupplement {
    case header
    case footer
    
    init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}
#endif
