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
                addInnerItemIfNotContains(indexPath)
                reload(using: parent, at: indexPath)
            }                        
        }
        
        func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?) {
            inners.forEach {
                guard let view = parent?.supplementaryView(forElementKind: kind, at: $0.key) as? InnerVisibilityTrackerInterface else { return }
                view.refreshSeenDataToInnerCollectionView()
            }
        }
        
        func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath) {
            guard let inner = inners.first(where: { $0.key == key }),
                  let view = parent?.supplementaryView(forElementKind: kind, at: inner.key) as? InnerVisibilityTrackerInterface
            else { return }
                
            view.configureInnerCollectionView(inner.data)
        }
        
    }

}
#endif
