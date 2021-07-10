//
//  InnerCollectionViewModel.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import Foundation

protocol InnerViewModelListInterface: AnyObject {
    var type: VisibilityTrackableViewType { get }
    var inners: [VisibilityTrackableCollectionView.InnerViewModel] { get set }
    
    func findInnerItem(using key: IndexPath) -> VisibilityTrackableCollectionView.InnerViewModel?
    func updateInnerCollectionFullyVisible(using parent: VisibilityTrackableCollectionViewInterface)
    func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?)
    func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath)
    func refresh()
    func addInnerItemIfNotContains(_ key: IndexPath)
}

extension InnerViewModelListInterface {
    
    func findInnerItem(using key: IndexPath) -> VisibilityTrackableCollectionView.InnerViewModel? {
        inners.first(where: { $0.key == key })
    }
    
    func isInnerItemContains(_ key: IndexPath) -> Bool {
        inners.contains(where: { $0.key == key })
    }
    
    func addInnerItemIfNotContains(_ key: IndexPath) {
        if isInnerItemContains(key) { return }
        inners.append(.init(key: key))
    }
    
    func refresh() {
        inners.forEach { $0.data.refreshSeenData() }
        inners = []
    }
    
}
#endif
