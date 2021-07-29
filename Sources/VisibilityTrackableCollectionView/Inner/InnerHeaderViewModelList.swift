//
//  InnerHeaderViewModelList.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {
    
    final class InnerHeaderViewModelList: InnerViewModelListInterface {
        var type: VisibilityTrackableViewType { .header }
        private let kind = UICollectionView.elementKindSectionHeader
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
            parent: VisibilityTrackableCollectionViewInterface?,
            key: IndexPath
        ) -> (InnerVisibilityTrackerInterface, InnerViewModel)? {
            guard
                let inner = inners.first(where: { $0.key == key }),
                let view = parent?.supplementaryView(
                    forElementKind: kind,
                    at: inner.key
                ) as? InnerVisibilityTrackerInterface
            else {
                return nil
            }
            
            return (view, inner)
        }

        func findInnerVisibilityTracker(
            using inner: InnerViewModel,
            in parent: VisibilityTrackableCollectionViewInterface?
        ) -> InnerVisibilityTrackerInterface? {
            parent?.supplementaryView(forElementKind: kind, at: inner.key) as? InnerVisibilityTrackerInterface
        }
        
    }

}
#endif
