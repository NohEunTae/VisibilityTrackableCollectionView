//
//  UICollectionReusableViewExtension.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
// 
//

#if os(iOS)
import UIKit

extension UICollectionReusableView {
    
    func currentIndexPath(elementKind kind: String) -> IndexPath? {
        guard let superCollectionView = superview as? UICollectionView else { return nil }
        return superCollectionView.indexPathForVisibleSupplementaryView(for: self, ofKind: kind)
    }
    
}
#endif
