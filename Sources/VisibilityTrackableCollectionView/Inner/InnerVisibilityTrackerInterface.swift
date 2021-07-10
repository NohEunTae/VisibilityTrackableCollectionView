//
//  InnerVisibilityTrackerInterface.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import UIKit

protocol InnerVisibilityTrackerInterface {
    var collectionViewInner: VisibilityTrackableCollectionView? { get }
    
    func configureInnerCollectionView(_ item: VisibilityTrackableCollectionView.ViewModel)
    func refreshSeenDataToInnerCollectionView()
}

extension InnerVisibilityTrackerInterface {
    
    func configureInnerCollectionView(_ item: VisibilityTrackableCollectionView.ViewModel) {
        collectionViewInner?.configure(viewModel: item)
    }
    
    func refreshSeenDataToInnerCollectionView() {
        collectionViewInner?.refreshSeenData()
    }
    
}
#endif
