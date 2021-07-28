//
//  InnerFooterViewModelList.swift
//
//
//  Created by NohEunTae on 2021/07/01.
// 
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {

    final class InnerFooterViewModelList: InnerViewModelListInterface {
        var type: VisibilityTrackableViewType { .footer }
        
        private let kind = UICollectionView.elementKindSectionFooter
        var inners: [InnerViewModel] = []
        
        func updateInnerCollectionFullyVisible(using parent: VisibilityTrackableCollectionViewInterface) {
            guard parent.visibleSupplementaryViews(ofKind: kind).isNotEmpty else { return }
            
            let indexPaths = parent.visibleSupplementaryViews(ofKind: kind).compactMap { view -> IndexPath? in
                guard let _ = view as? InnerVisibilityTrackerInterface else { return nil }
                return view.currentIndexPath(elementKind: kind)
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
                let inner = inners.first(where: { $0.key == key })
                , let view = parent?.supplementaryView(forElementKind: kind, at: inner.key) as? InnerVisibilityTrackerInterface
            else {
                return nil
            }
            
            return (view, inner)
        }
        
        func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?) {
            var removeItems: [InnerViewModel] = []
            inners.forEach {
                guard
                    let view = parent?.supplementaryView(
                        forElementKind: kind,
                        at: $0.key
                    ) as? InnerVisibilityTrackerInterface
                else {
                    $0.isNeedRefresh = true
                    return
                }
                view.refreshSeenDataToInnerCollectionView()
                $0.data.refreshSeenData()
                removeItems.append($0)
            }
            
            removeItems.forEach { removeInner(inner: $0) }
        }
        
        func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath) {
            guard
                let inner = inners.first(where: { $0.key == key }),
                let view = parent?.supplementaryView(
                    forElementKind: kind,
                    at: inner.key
                ) as? InnerVisibilityTrackerInterface
            else {
                return
            }
            
            view.configureInnerCollectionView(inner.data)
        }
        
    }

}
#endif
