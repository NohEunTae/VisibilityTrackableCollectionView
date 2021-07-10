//
//  UICollectionViewExtension.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//

#if os(iOS)
import UIKit

extension UICollectionView {
    
    private func findSuperVC(_ responder: UIResponder) -> UIViewController? {
        guard let next = responder.next else { return nil }
        
        guard let vc = next as? UIViewController else {
            return findSuperVC(next)
        }
        
        return vc
    }

    var fullyVisibleCells: [UICollectionViewCell] {
        let superVC = findSuperVC(self)
        return visibleCells.filter {
            guard let superview = superVC?.view else {
                return bounds.contains($0.frame)
            }
            
            let cellRect = convert($0.frame, to: superview)
            return superview.bounds.contains(cellRect)
        }
    }
    
    var fullyVisibleCellIndexPaths: [IndexPath] {
        fullyVisibleCells
            .compactMap { indexPath(for: $0) }
    }

    func fullyVisibleReusableViews(ofKind elementKind: String) -> [UICollectionReusableView] {
        let superVC = findSuperVC(self)
        return visibleSupplementaryViews(ofKind: elementKind)
            .filter {
                guard let superview = superVC?.view else {
                    return bounds.contains($0.frame)
                }
                
                let viewRect = convert($0.frame, to: superview)
                return superview.bounds.contains(viewRect)
            }
    }
    
    func fullyVisibleReusableIndexPaths(ofKind elementKind: String) -> [IndexPath] {
        fullyVisibleReusableViews(ofKind: elementKind)
            .compactMap { indexPathForVisibleSupplementaryView(for:$0, ofKind: elementKind) }
    }
    
    func indexPathForVisibleSupplementaryView(for view: UICollectionReusableView, ofKind elementKind: String) -> IndexPath? {
        let indexPaths = indexPathsForVisibleSupplementaryElements(ofKind: elementKind)
        let views = visibleSupplementaryViews(ofKind: elementKind)
        let items: [(indexPath: IndexPath, reusableView: UICollectionReusableView)] = Array(zip(indexPaths, views))
        
        return items.first { $0.reusableView == view }?.indexPath
    }

}
#endif
