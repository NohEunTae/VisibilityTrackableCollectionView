//
//  VisibleFooterItemManager.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {
    
    final class VisibleFooterItemManager: VisibleItemManageable {
        private let kind = UICollectionView.elementKindSectionFooter
        var items = Set<IndexPath>()
        var type: VisibilityTrackableViewType { .footer }
        
        func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
            current.fullyVisibleReusableIndexPaths(ofKind: kind)
        }
        
    }
    
}
#endif
