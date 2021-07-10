//
//  VisibleItemManageable.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import Foundation

protocol VisibleItemManageable: AnyObject {
    var items: Set<IndexPath> { get set }
    var type: VisibilityTrackableViewType { get }
    func refreshSeenData()
    
    func fullyVisibleIndexPaths(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath]
    func firstAppearedItems(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath]
    
    func updateFullyVisibleItemsFirstAppeared(in current: VisibilityTrackableCollectionViewInterface) -> ([IndexPath], VisibilityTrackableViewType)
    func updateFullyVisibleItems(in current: VisibilityTrackableCollectionViewInterface) -> ([IndexPath], VisibilityTrackableViewType)
}

extension VisibleItemManageable {
    func refreshSeenData() { items = [] }
    
    func firstAppearedItems(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
        fullyVisibleIndexPaths(in: current)
            .filter { !items.contains($0) }
    }

    func updateFullyVisibleItemsFirstAppeared(in current: VisibilityTrackableCollectionViewInterface) -> ([IndexPath], VisibilityTrackableViewType) {
        let firstAppearedItems = firstAppearedItems(in: current)
        items.insert(firstAppearedItems)
        
        return (firstAppearedItems, type)
    }
        
    func updateFullyVisibleItems(in current: VisibilityTrackableCollectionViewInterface) -> ([IndexPath], VisibilityTrackableViewType) {
        return (fullyVisibleIndexPaths(in: current), type)
    }

}
#endif
