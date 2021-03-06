//
//  SingleInnerCollectionViewCell.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/01.
//

import UIKit
import VisibilityTrackableCollectionView

final class SingleInnerCollectionViewCell: UICollectionViewCell, InnerVisibilityTrackerInterface {
    
    var collectionViewInner: VisibilityTrackableCollectionView? { collectionView }
    
    @IBOutlet private weak var collectionView: VisibilityTrackableCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerCellXib(cellClass: TextCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SingleInnerCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
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
        
        cell.configure("\(indexPath.item)")
        return cell
    }
}

extension SingleInnerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 3) - 10, height: 100)
    }
}

extension SingleInnerCollectionViewCell: CollectionViewDelegateVisibleItems {
    func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath]) {
        print("single inner firstTimeOfFullyVisibleItems: \(items)")
    }
}
