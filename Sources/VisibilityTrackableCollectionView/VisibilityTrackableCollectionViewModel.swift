//
//  VisibilityTrackableCollectionViewModel.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import Foundation

extension VisibilityTrackableCollectionView {
    
    final class ViewModel {
        
        enum FullyVisibleState {
            typealias Data = (indexPaths: [IndexPath], type: VisibilityTrackableViewType)
            
            case all(Data)
            case first(Data)
        }
        
        var visibleState: ((FullyVisibleState) -> Void)?
        
        private let innerViewModelLists: [InnerViewModelListInterface] = [
            InnerCellViewModelList(),
            InnerHeaderViewModelList(),
            InnerFooterViewModelList()
        ]

        private let visibleItemManagers: [VisibleItemManageable] = [
            VisibleCellItemManager(),
            VisibleHeaderItemManager(),
            VisibleFooterItemManager()
        ]
        
        func refreshSeenData() {
            visibleItemManagers.forEach { $0.refreshSeenData() }
            innerViewModelLists.forEach { $0.refresh() }
        }
        
        func reloadInner(
            type: VisibilityTrackableViewType,
            parent: VisibilityTrackableCollectionViewInterface?,
            at key: IndexPath
        ) {
            innerViewModelLists
                .first(where: { $0.type == type })?
                .reload(using: parent, at: key)
        }
        
        func updateInners(parent: VisibilityTrackableCollectionViewInterface) {
            innerViewModelLists.forEach {
                $0.updateInnerCollectionFullyVisible(using: parent)
            }
        }
        
        func notiRefreshToAllInners(parent: VisibilityTrackableCollectionViewInterface?) {
            innerViewModelLists.forEach {
                $0.notiRefreshToInner(using: parent)
            }
        }
        
        func updateVisibleItems(current: VisibilityTrackableCollectionViewInterface) {
            visibleItemManagers.forEach {
                visibleState?(.first($0.updateFullyVisibleItemsFirstAppeared(in: current)))
                visibleState?(.all($0.updateFullyVisibleItems(in: current)))
            }
        }
        
        func findCurrentItems(_ type: VisibilityTrackableViewType) -> [IndexPath] {
            Array(visibleItemManagers.first(where: { $0.type == type })?.items ?? [])
        }
        
    }
    
}
#endif
