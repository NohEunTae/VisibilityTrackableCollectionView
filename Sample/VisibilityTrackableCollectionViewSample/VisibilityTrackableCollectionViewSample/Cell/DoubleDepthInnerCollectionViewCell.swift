//
//  DoubleDepthInnerCollectionViewCell.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/01.
//

import UIKit
import VisibilityTrackableCollectionView

final class DoubleDepthInnerCollectionViewCell: UICollectionViewCell, InnerVisibilityTrackerInterface {

    var collectionViewInner: VisibilityTrackableCollectionView? { collectionView }
    
    @IBOutlet private weak var collectionView: VisibilityTrackableCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.registerCellXib(cellClass: SingleInnerCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension DoubleDepthInnerCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(
            withReuseIdentifier: SingleInnerCollectionViewCell.className
            , for: indexPath
        )
    }
}

extension DoubleDepthInnerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 3) - 10, height: 100)
    }
}
