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
    typealias InnerViewModel = VisibilityTrackableCollectionView.InnerViewModel
    
    var type: VisibilityTrackableViewType { get }
    var inners: [VisibilityTrackableCollectionView.InnerViewModel] { get set }
    
    func findInnerItem(using key: IndexPath) -> VisibilityTrackableCollectionView.InnerViewModel?
    func updateInnerCollectionFullyVisible(using parent: VisibilityTrackableCollectionViewInterface)
    func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?)
    func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath)
    func refresh()
    func addInnerItemIfNotContains(_ key: IndexPath)
    func findInnerVisibilityTracker(
        parent: VisibilityTrackableCollectionViewInterface?,
        key: IndexPath
     ) -> (InnerVisibilityTrackerInterface, InnerViewModel)?
}

extension InnerViewModelListInterface {
    
    func findInnerItem(using key: IndexPath) -> InnerViewModel? {
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
    
    func refreshIfNeeded(
        inner: InnerViewModel,
        innerTracker: InnerVisibilityTrackerInterface
    ) {
        guard inner.isNeedRefresh else { return }
        innerTracker.refreshSeenDataToInnerCollectionView()
        inner.data.refreshSeenData()
        removeInner(inner: inner)
    }

    func removeInner(inner: InnerViewModel) {
        inners = inners.filter { $0.key != inner.key }
    }

    func reload(
        inner: InnerViewModel,
        innerTracker: InnerVisibilityTrackerInterface
    ) {
        innerTracker.configureInnerCollectionView(inner.data)
    }
    
}
#endif
