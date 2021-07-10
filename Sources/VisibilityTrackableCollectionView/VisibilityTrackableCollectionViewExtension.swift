//
//  VisibilityTrackableCollectionViewExtension.swift
//  
//
//  Created by NohEunTae on 2021/07/01.
//

#if os(iOS)
import UIKit

extension VisibilityTrackableCollectionView {
    
    private func findSuperVC(_ responder: UIResponder) -> UIViewController? {
        guard let next = responder.next else { return nil }
        
        guard let vc = next as? UIViewController else {
            return findSuperVC(next)
        }
        
        return vc
    }
    
    private func fullyVisibleItems<T: UIView>(views: [T]) -> [T] {
        if let boundary = boundaryManager.boundary,
           let boundaryView = boundary.view {
            return views.filter {
                let viewRect = convert($0.frame, to: boundaryView)
                return boundary.rect.contains(viewRect) && bounds.contains($0.frame)
            }
        }
        
        let superVC = findSuperVC(self)
        return views.filter {
            guard let superview = superVC?.view else {
                return bounds.contains($0.frame)
            }
            
            let viewRect = convert($0.frame, to: superview)
            return superview.bounds.contains(viewRect) && bounds.contains($0.frame)
        }
    }
    
    var fullyVisibleCells: [UICollectionViewCell] {
        fullyVisibleItems(views: visibleCells)
    }
    
    var fullyVisibleCellIndexPaths: [IndexPath] {
        fullyVisibleCells
            .compactMap { indexPath(for: $0) }
    }
    
    func fullyVisibleReusableViews(ofKind elementKind: String) -> [UICollectionReusableView] {
        fullyVisibleItems(views: visibleSupplementaryViews(ofKind: elementKind))
    }
    
    func fullyVisibleReusableIndexPaths(ofKind elementKind: String) -> [IndexPath] {
        fullyVisibleReusableViews(ofKind: elementKind)
            .compactMap { indexPathForVisibleSupplementaryView(for:$0, ofKind: elementKind) }
    }
        
}

extension UICollectionView {
    
    func indexPathForVisibleSupplementaryView(for view: UICollectionReusableView, ofKind elementKind: String) -> IndexPath? {
        let indexPaths = indexPathsForVisibleSupplementaryElements(ofKind: elementKind)
        let views = visibleSupplementaryViews(ofKind: elementKind)
        let items: [(indexPath: IndexPath, reusableView: UICollectionReusableView)] = Array(zip(indexPaths, views))
        
        return items.first { $0.reusableView == view }?.indexPath
    }
    
}
#endif
