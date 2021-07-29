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
    func notiRefreshToInner(
        using parent: VisibilityTrackableCollectionViewInterface?,
        sections: [Int]
    )
    func reload(using parent: VisibilityTrackableCollectionViewInterface?, at key: IndexPath)
    func refresh()
    func addInnerItemIfNotContains(_ key: IndexPath)
    func findInnerVisibilityTracker(
        using inner: InnerViewModel,
        in parent: VisibilityTrackableCollectionViewInterface?
    ) -> InnerVisibilityTrackerInterface?
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

    func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?) {
        var removeItems: [InnerViewModel] = []
        inners.forEach {
            guard let innerTracker = findInnerVisibilityTracker(using: $0, in: parent) else {
                $0.isNeedRefresh = true
                return
            }
            innerTracker.refreshSeenDataToInnerCollectionView()
            $0.data.refreshSeenData()
            removeItems.append($0)
        }
        
        removeItems.forEach { removeInner(inner: $0) }
    }
    
    func notiRefreshToInner(using parent: VisibilityTrackableCollectionViewInterface?, sections: [Int]) {
        let removeInners = inners.filter { sections.contains($0.key.section) }
        var removeItems: [InnerViewModel] = []
        removeInners.forEach {
            guard let innerTracker = findInnerVisibilityTracker(using: $0, in: parent) else {
                $0.isNeedRefresh = true
                return
            }
            innerTracker.refreshSeenDataToInnerCollectionView()
            $0.data.refreshSeenData()
            removeItems.append($0)
        }
        
        removeItems.forEach { removeInner(inner: $0) }
    }

    private func removeInner(inner: InnerViewModel) {
        inners = inners.filter { $0.key != inner.key }
    }

    func reload(
        inner: InnerViewModel,
        innerTracker: InnerVisibilityTrackerInterface
    ) {
        innerTracker.configureInnerCollectionView(inner.data)
    }
    
    func reload(
        using parent: VisibilityTrackableCollectionViewInterface?
        , at key: IndexPath
    ) {
        guard let inner = inners.first(where: { $0.key == key })
              , let innerTracker = findInnerVisibilityTracker(using: inner, in: parent)
        else {
            return
        }
            
        innerTracker.configureInnerCollectionView(inner.data)
    }

}
#endif
