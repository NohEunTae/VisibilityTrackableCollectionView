//
//  Registrable.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit

protocol CellRegistrable {
    func register(cellClass: AnyClass)
    func registerCellXib(cellClass: AnyClass)
}

enum SectionSupplement {
    case header
    case footer
    
    public init?(rawValue: String) {
        switch rawValue {
        case UICollectionView.elementKindSectionHeader: self = .header
        case UICollectionView.elementKindSectionFooter: self = .footer
        default: return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

protocol SupplementaryViewRegistrable {
    func register(viewClass: AnyClass, supplement: SectionSupplement)
    func registerViewXib(viewClass: AnyClass, supplement: SectionSupplement)
}

typealias Registrable = CellRegistrable & SupplementaryViewRegistrable

extension UICollectionView: Registrable {
    func register(cellClass: AnyClass) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func registerCellXib(cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func register(viewClass: AnyClass, supplement: SectionSupplement) {
        let className = String(describing: viewClass)
        register(viewClass, forSupplementaryViewOfKind: supplement.rawValue, withReuseIdentifier: className)
    }
    
    func registerViewXib(viewClass: AnyClass, supplement: SectionSupplement) {
        let className = String(describing: viewClass)
        let nib = UINib(nibName: className, bundle: nil)
        register(nib, forSupplementaryViewOfKind: supplement.rawValue, withReuseIdentifier: className)
    }
}

extension UITableView: CellRegistrable {
    func register(cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func registerCellXib(cellClass: AnyClass) {
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }
}
