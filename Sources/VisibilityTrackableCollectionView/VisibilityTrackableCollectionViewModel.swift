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
    
    public class ViewModel {
        
        enum FullyVisibleState {
            typealias Data = (indexPaths: [IndexPath], type: VisibilityTrackableViewType)
            
            case all(Data)
            case first(Data)
            case infinite(Data)
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
        
        private let infiniteVisibleItemManagers: [InfiniteVisibleItemManageable] = [
            InfiniteVisibleCellItemManager(),
            InfiniteVisibleHeaderItemManager(),
            InfiniteVisibleFooterItemManager()
        ]
        
        func refreshSeenData() {
            visibleItemManagers.forEach { $0.refreshSeenData() }
            infiniteVisibleItemManagers.forEach { $0.refreshSeenData() }
        }
        
        func refreshSections(_ sections: [Int]) {
            (visibleItemManagers + infiniteVisibleItemManagers).forEach {
                $0.refreshSections(sections)
            }
        }
        
        func refreshInfiniteItems(type: VisibilityTrackableViewType) {
            infiniteVisibleItemManagers
                .first { $0.type == type }?
                .refreshInifiniteItems()
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
        
        func notiRefreshToAllInners(parent: VisibilityTrackableCollectionViewInterface?, sections: [Int]) {
            innerViewModelLists.forEach { innerViewModelList in
                innerViewModelList.notiRefreshToInner(using: parent, sections: sections)
            }
        }

        func updateVisibleItems(current: VisibilityTrackableCollectionViewInterface) {
            visibleItemManagers.forEach {
                visibleState?(.first($0.updateFullyVisibleItemsFirstAppeared(in: current)))
                visibleState?(.all($0.updateFullyVisibleItems(in: current)))
            }
            
            infiniteVisibleItemManagers.forEach {
                visibleState?(.infinite($0.updateFullyVisibleItemsFirstAppeared(in: current)))
            }
        }
        
        func setInfiniteScroll(infiniteItem: InfiniteItem, type: VisibilityTrackableViewType) {
            infiniteVisibleItemManagers
                .first { $0.type == type }?
                .setInfiniteItem(infiniteItem)
        }

        func findCurrentItems(_ type: VisibilityTrackableViewType) -> [IndexPath] {
            Array(visibleItemManagers.first(where: { $0.type == type })?.items ?? [])
        }
        
    }
    
}
#endif
