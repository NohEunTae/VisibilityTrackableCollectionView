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
            parent: VisibilityTrackableCollectionViewInterface?
            , key: IndexPath
        ) -> (InnerVisibilityTrackerInterface, InnerViewModel)? {
            guard
                let inner = inners.first(where: { $0.key == key }),
                let innerCell = parent?.cellForItem(at: inner.key) as? InnerVisibilityTrackerInterface
            else {
                return nil
            }

            return (innerCell, inner)
        }
        
        func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?) {
            var removeItems: [InnerViewModel] = []
            inners.forEach {
                guard
                    let cell = parent?.cellForItem(at: $0.key) as? InnerVisibilityTrackerInterface
                else {
                    $0.isNeedRefresh = true
                    return
                }
                
                cell.refreshSeenDataToInnerCollectionView()
                $0.data.refreshSeenData()
                removeItems.append($0)
            }
            
            removeItems.forEach { removeInner(inner: $0) }
        }
        
        private func removeInner(inner: InnerViewModel) {
            inners = inners.filter { $0.key != inner.key }
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
