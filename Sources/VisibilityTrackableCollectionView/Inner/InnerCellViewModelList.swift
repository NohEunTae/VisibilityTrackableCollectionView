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
                guard
                    let (innerTracker, inner) = findInnerVisibilityTracker(parent: parent, key: indexPath)
                else {
                    addInnerItemIfNotContains(indexPath)
                    return
                }
                refreshIfNeeded(inner: inner, innerTracker: innerTracker)
                addInnerItemIfNotContains(indexPath)
                reload(inner: inner, innerTracker: innerTracker)
            }
        }

        func findInnerVisibilityTracker(
            parent: VisibilityTrackableCollectionViewInterface?,
            key: IndexPath
        ) -> (InnerVisibilityTrackerInterface, InnerViewModel)? {
            guard
                let inner = inners.first(where: { $0.key == key }),
                let innerCell = parent?.cellForItem(at: inner.key) as? InnerVisibilityTrackerInterface
            else {
                return nil
            }

            return (innerCell, inner)
        }
        
        func findInnerVisibilityTracker(
            using inner: InnerViewModel,
            in parent: VisibilityTrackableCollectionViewInterface?
        ) -> InnerVisibilityTrackerInterface? {
            parent?.cellForItem(at: inner.key) as? InnerVisibilityTrackerInterface
        }

    }

}
#endif
