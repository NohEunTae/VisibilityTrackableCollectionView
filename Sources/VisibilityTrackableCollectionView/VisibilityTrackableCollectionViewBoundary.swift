//
//  VisibilityTrackableCollectionViewBoundary.swift
//  
//
//  Created by NohEunTae on 2021/07/10.
//

import UIKit

extension VisibilityTrackableCollectionView {
    
    public final class Boundary {
        
        public enum Mode {
            case full, safeArea
        }
        
        private(set) weak var view: UIView?
        let mode: Mode
        
        public init(view: UIView, mode: Mode = .full) {
            self.view = view
            self.mode = mode
        }
        
        var rect: CGRect {
            guard let view = view else { return .zero }
            switch mode {
            case .full: return view.bounds
            case .safeArea: return view.safeAreaLayoutGuide.layoutFrame
            }
        }
        
    }
    
    final class BoundaryManager {
        private weak var owner: UIView?
        
        init(owner: UIView) {
            self.owner = owner
        }
        
        private func outer(_ view: UIView?) -> VisibilityTrackableCollectionView? {
            guard let superview = view?.superview else { return nil }
            
            guard let outer = superview as? VisibilityTrackableCollectionView else {
                return outer(superview)
            }
            
            return outer
        }
        
        private var _boundary: Boundary?
        var boundary: Boundary? {
            get {
                if let boundary = _boundary { return boundary }
                return outer(owner)?.boundaryManager.boundary
            }
            
            set {
                _boundary = newValue
            }
        }
    }
    
}

