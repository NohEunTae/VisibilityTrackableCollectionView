//
//  NestedItemApater.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit
import VisibilityTrackableCollectionView

final class NestedCollectionViewApater: NSObject {
    
    private enum Section: Int, CaseIterable {
        case normal1
        case doubleDepthInner
        case normal2
        case singleDepthInner
        
        var numberOfItems: Int {
            switch self {
            case .normal1: return 10
            case .doubleDepthInner: return 2
            case .normal2: return 20
            case .singleDepthInner: return 2
            }
        }
    }
    
    func setRequirements(collectionView: UICollectionView) {
        collectionView.registerCellXib(cellClass: TextCollectionViewCell.self)
        collectionView.registerCellXib(cellClass: DoubleDepthInnerCollectionViewCell.self)
        collectionView.registerCellXib(cellClass: SingleInnerCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

}

extension NestedCollectionViewApater: UICollectionViewDataSource {
 
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Section(rawValue: section)?.numberOfItems ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .normal1, .normal2:
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
        case .doubleDepthInner:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: DoubleDepthInnerCollectionViewCell.className,
                for: indexPath
            )
        case .singleDepthInner:
            return collectionView.dequeueReusableCell(
                withReuseIdentifier: SingleInnerCollectionViewCell.className,
                for: indexPath
            )
        default:
            return .init()
        }
    }

}

extension NestedCollectionViewApater: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch Section(rawValue: indexPath.section) {
        case .normal1, .normal2:
            return .init(width: (collectionView.frame.width / 3) - 10, height: 300)
        case .singleDepthInner, .doubleDepthInner:
            return .init(width: collectionView.frame.width, height: 100)
        default:
            return .zero
        }
    }
    
}

extension NestedCollectionViewApater: CollectionViewDelegateVisibleItems {
    
    func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath]) {
        print("firstTimeOfFullyVisibleItems: \(items)")
    }
    
}
