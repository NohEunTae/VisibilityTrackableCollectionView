//
//  InfiniteScrollAdapter.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit
import VisibilityTrackableCollectionView

final class InfiniteScrollAdapter: NSObject {
    private var numberOfItems: Int = .zero
    
    func setRequirements(collectionView: VisibilityTrackableCollectionView, numberOfItems: Int) {
        self.numberOfItems = numberOfItems
        collectionView.registerCellXib(cellClass: TextCollectionViewCell.self)
        collectionView.setInfiniteScroll(infiniteItem: InfiniteItem(section: .zero, numberOfItems: numberOfItems), type: .cell)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension InfiniteScrollAdapter: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems * 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TextCollectionViewCell.className,
                for: indexPath
            ) as? TextCollectionViewCell
        else {
            fatalError("dequeue failed")
        }
        
        cell.configure("\(indexPath.item % numberOfItems)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: (collectionView.frame.width / 3) - 10, height: 300)
    }
    
}

extension InfiniteScrollAdapter: CollectionViewDelegateVisibleItems {

    func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath]) {
        print("firstTimeOfFullyVisibleItems: \(items)")
    }

    func collectionView(_ collectionView: UICollectionView, infinityOfFullyVisibleItems items: [IndexPath]) {
        print("infinityOfFullyVisibleItems: \(items)")
    }
}

