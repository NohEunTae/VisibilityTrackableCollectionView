//
//  UICollectionViewCellExtension.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//

#if os(iOS)
import UIKit

extension UICollectionViewCell {
    
    var currentIndexPath: IndexPath? {
        guard let superCollectionView = superview as? UICollectionView else { return nil }
        return superCollectionView.indexPath(for: self)
    }
    
}
#endif
