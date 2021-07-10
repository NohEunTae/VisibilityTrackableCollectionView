//
//  VisibilityTrackableCollectionView.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import UIKit

@objc protocol CollectionViewDelegateVisibleItems: UICollectionViewDelegate {
    @objc optional func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath])
    @objc optional func collectionView(_ collectionView: UICollectionView, allOfFullyVisibleItems items: [IndexPath])
    @objc optional func collectionView(_ collectionView: UICollectionView, supplementaryElementOfKind kind: String, firstTimeOfFullyVisibleItems items: [IndexPath])
    @objc optional func collectionView(_ collectionView: UICollectionView, supplementaryElementOfKind kind: String, allOfFullyVisibleItems items: [IndexPath])
}

protocol VisibilityTrackableCollectionViewInterface: AnyObject {
    var visibleCells: [UICollectionViewCell] { get }
    var fullyVisibleCells: [UICollectionViewCell] { get }
    var fullyVisibleCellIndexPaths: [IndexPath] { get }
    
    func indexPath(for cell: UICollectionViewCell) -> IndexPath?
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell?
    func supplementaryView(forElementKind: String, at indexPath: IndexPath) -> UICollectionReusableView?
    
    func visibleSupplementaryViews(ofKind elementKind: String) -> [UICollectionReusableView]
    func fullyVisibleReusableViews(ofKind elementKind: String) -> [UICollectionReusableView]
    func fullyVisibleReusableIndexPaths(ofKind elementKind: String) -> [IndexPath]
}

class VisibilityTrackableCollectionView: UICollectionView, VisibilityTrackableCollectionViewInterface {
    
    private var viewModel = ViewModel() {
        didSet { bind() }
    }
    
    private var delegateVisibleItems: CollectionViewDelegateVisibleItems? {
        delegate as? CollectionViewDelegateVisibleItems
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        bind()
    }
    
    override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let _ = cell as? InnerVisibilityTrackerInterface {
            viewModel.reloadInner(type: .cell, parent: self, at: indexPath)
        }
        
        return cell
    }
    
    override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let view = super.dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
        
        if let _ = view as? InnerVisibilityTrackerInterface {
            switch SectionSupplement(rawValue: elementKind) {
            case .header:
                viewModel.reloadInner(type: .header, parent: self, at: indexPath)
            case .footer:
                viewModel.reloadInner(type: .footer, parent: self, at: indexPath)
            default: break
            }
        }
        
        return view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateFullyVisibleItemsIfNeeded()
    }

    func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        updateFullyVisibleItemsIfNeeded()
    }
    
    func refreshSeenData() {
        viewModel.notiRefreshToAllInners(parent: self)
        viewModel.refreshSeenData()
        updateFullyVisibleItemsIfNeeded()
    }

    private func updateFullyVisibleItemsIfNeeded() {
        viewModel.updateInners(parent: self)
        guard let _ = delegateVisibleItems else { return }
        
        viewModel.updateVisibleItems(current: self)
    }

}

// MARK:- bind
private extension VisibilityTrackableCollectionView {

    func bind() {
        viewModel.visibleState = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .all(let data):
                self.fullyVisibleAll(indexPaths: data.indexPaths, type: data.type)
            case .first(let data):
                self.fullyVisibleFirstTime(indexPaths: data.indexPaths, type: data.type)
            }
        }
    }
    
    func fullyVisibleAll(indexPaths: [IndexPath], type: VisibilityTrackableViewType) {
        guard indexPaths.isNotEmpty else { return }
        switch type {
        case .cell:
            delegateVisibleItems?.collectionView?(self, allOfFullyVisibleItems: indexPaths)
        case .header:
            delegateVisibleItems?.collectionView?(self, supplementaryElementOfKind: SectionSupplement.header.rawValue, allOfFullyVisibleItems: indexPaths)
        case .footer:
            delegateVisibleItems?.collectionView?(self, supplementaryElementOfKind: SectionSupplement.footer.rawValue, allOfFullyVisibleItems: indexPaths)
        }
    }
    
    func fullyVisibleFirstTime(indexPaths: [IndexPath], type: VisibilityTrackableViewType) {
        guard indexPaths.isNotEmpty else { return }
        switch type {
        case .cell:
            delegateVisibleItems?.collectionView?(self, firstTimeOfFullyVisibleItems: indexPaths)
        case .header:
            delegateVisibleItems?.collectionView?(self, supplementaryElementOfKind: SectionSupplement.header.rawValue, firstTimeOfFullyVisibleItems: indexPaths)
        case .footer:
            delegateVisibleItems?.collectionView?(self, supplementaryElementOfKind: SectionSupplement.footer.rawValue, firstTimeOfFullyVisibleItems: indexPaths)
        }
    }

}
#endif
