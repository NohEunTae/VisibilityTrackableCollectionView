//
//  InnerCellViewModelList.swift
// 
//
//  Created by NohEunTae on 2021/07/01.
//
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {

    final class InnerCellViewModelList: InnerViewModelListInterface {
        var type: VisibilityTrackableViewType { .cell }
        var inners: [InnerViewModel] = []
        
        func updateInnerCollectionFullyVisible(using parent: VisibilityTrackableCollectionViewInterface) {
            guard parent.visibleCells.isNotEmpty else { return }
            
            let indexPaths = parent.visibleCells.compactMap { cell -> IndexPath? in
                guard let _ = cell as? InnerVisibilityTrackerInterface else { return nil }
                return cell.currentIndexPath
            }
            
            guard indexPaths.isNotEmpty else { return }
            
            indexPaths.forEach { indexPath in
                addInnerItemIfNotContains(indexPath)
                reload(using: parent, at: indexPath)
            }
        }
        
        func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?) {
            inners.forEach {
                guard let cell = parent?.cellForItem(at: $0.key) as? InnerVisibilityTrackerInterface else { return }
                cell.refreshSeenDataToInnerCollectionView()
            }
        }
        
        func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath) {
            guard let inner = inners.first(where: { $0.key == key }),
                  let innerCell = parent?.cellForItem(at: inner.key) as? InnerVisibilityTrackerInterface
            else { return }
                
            innerCell.configureInnerCollectionView(inner.data)
        }
        
    }

}
#endif
