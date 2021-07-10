//
//  SingleInnerCollectionViewCell.swift
//  BrandiVisibilityTrackerSample
//
//  Created by NohEunTae on 2021/07/01.
//

import UIKit
import VisibilityTrackableCollectionView

final class SingleInnerCollectionViewCell: UICollectionViewCell, InnerVisibilityTrackerInterface {
    static let cellIdentifier: String = "SingleInnerCell"
    
    var collectionViewInner: VisibilityTrackableCollectionView? { collectionView }
    
    @IBOutlet private weak var collectionView: VisibilityTrackableCollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "TextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TextCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SingleInnerCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.cellIdentifier, for: indexPath) as? TextCollectionViewCell else { return .init() }
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
