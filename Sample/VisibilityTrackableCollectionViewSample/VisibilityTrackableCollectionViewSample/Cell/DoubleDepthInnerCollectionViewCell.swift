//
//  DoubleDepthInnerCollectionViewCell.swift
//  BrandiVisibilityTrackerSample
//
//  Created by NohEunTae on 2021/07/01.
//

import UIKit
import VisibilityTrackableCollectionView

final class DoubleDepthInnerCollectionViewCell: UICollectionViewCell, InnerVisibilityTrackerInterface {
    static let cellIdentifier: String = "DoubleDepthInnerCell"

    var collectionViewInner: VisibilityTrackableCollectionView? { collectionView }
    
    @IBOutlet private weak var collectionView: VisibilityTrackableCollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "SingleInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SingleInnerCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension DoubleDepthInnerCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleInnerCollectionViewCell.cellIdentifier, for: indexPath) as? SingleInnerCollectionViewCell else { return .init() }
        return cell
    }
}

extension DoubleDepthInnerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: (collectionView.frame.width / 3) - 10, height: 100)
    }
}
