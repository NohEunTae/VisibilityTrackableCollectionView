//
//  VisibleHeaderItemManager.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {
    
    final class VisibleHeaderItemManager: VisibleItemManageable {
        private let kind = UICollectionView.elementKindSectionHeader
        var items = Set<IndexPath>()
        var type: VisibilityTrackableViewType { .header }
        
        func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
            current.fullyVisibleReusableIndexPaths(ofKind: kind)
        }

    }

}
#endif
