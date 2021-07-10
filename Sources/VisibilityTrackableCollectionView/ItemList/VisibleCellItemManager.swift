//
//  VisibleCellItemManager.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import Foundation

extension VisibilityTrackableCollectionView {
    
    final class VisibleCellItemManager: VisibleItemManageable {
        var items = Set<IndexPath>()
        var type: VisibilityTrackableViewType { .cell }
        
        func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
            current.fullyVisibleCellIndexPaths
        }

    }

}
#endif
