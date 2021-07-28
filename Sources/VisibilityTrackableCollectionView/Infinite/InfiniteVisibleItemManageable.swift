//
//  InfiniteVisibleItemManageable.swift
//  
//
//  Created by NohEunTae on 2021/07/28.
//

import Foundation

public struct InfiniteItem {
    let section: Int
    let numberOfItems: Int
    
    public init(section: Int, numberOfItems: Int) {
        self.section = section
        self.numberOfItems = numberOfItems
    }
}

protocol InfiniteVisibleItemManageable: VisibleItemManageable {
    var infiniteItems: [InfiniteItem] { set get }
    
    func setInfiniteItem(_ infiniteItem: InfiniteItem)
    func refreshInifiniteItems()
}

extension InfiniteVisibleItemManageable {
    
    func firstAppearedItems(in current: VisibilityTrackableCollectionViewInterface) -> [IndexPath] {
        if infiniteItems.isEmpty { return [] }
        return fullyVisibleIndexPaths(in: current)
            .compactMap { indexPath -> IndexPath? in
                if let sameSectionIndexInfo = infiniteItems
                    .first(where: { $0.section == indexPath.section }) {
                    let item = indexPath.item % sameSectionIndexInfo.numberOfItems
                    return IndexPath(item: item, section: indexPath.section)
                }
                return nil
            }
            .filter { !items.contains($0) }
    }
    
    func setInfiniteItem(_ infiniteItem: InfiniteItem) {
        if let index = infiniteItems.firstIndex(where: {
            $0.section == infiniteItem.section
        }) {
            infiniteItems.remove(at: index)
            items = items.filter { $0.section != infiniteItem.section }
        }
        infiniteItems.append(infiniteItem)
    }

    func refreshInifiniteItems() {
        infiniteItems = []
    }
}
