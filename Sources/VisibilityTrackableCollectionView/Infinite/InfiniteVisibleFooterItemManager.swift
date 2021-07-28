//
//  InfiniteVisibleFooterItemManager.swift
//  
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit

extension VisibilityTrackableCollectionView {
    
    final class InfiniteVisibleFooterItemManager: InfiniteVisibleItemManageable {
        private let kind = UICollectionView.elementKindSectionFooter
        var infiniteItems: [InfiniteItem] = []
        var items = Set<IndexPath>()
        var type: VisibilityTrackableViewType { .footer }
        
        func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
            current.fullyVisibleReusableIndexPaths(ofKind: kind)
        }
        
    }
    
}
