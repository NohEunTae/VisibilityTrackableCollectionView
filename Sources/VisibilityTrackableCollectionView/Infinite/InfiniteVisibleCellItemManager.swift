//
//  InfiniteVisibleCellItemManager.swift
//  
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit

extension VisibilityTrackableCollectionView {

    final class InfiniteVisibleCellItemManager: InfiniteVisibleItemManageable {
        var infiniteItems: [InfiniteItem] = []
        var items = Set<IndexPath>()
        var type: VisibilityTrackableViewType { .cell }
        
        func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
            current.fullyVisibleCellIndexPaths
        }
        
    }
    
}
