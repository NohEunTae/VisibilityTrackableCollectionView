//
//  VisibilityTrackableCollectionView.swift
//
//
//  Created by NohEunTae on 2021/07/01.
//  
//

#if os(iOS)
import UIKit

@objc public protocol CollectionViewDelegateVisibleItems: UICollectionViewDelegate {
    
    // Cell
    @objc optional func collectionView(
        _ collectionView: UICollectionView,
        firstTimeOfFullyVisibleItems items: [IndexPath]
    )
    
    @objc optional func collectionView(
        _ collectionView: UICollectionView
        , allOfFullyVisibleItems items: [IndexPath]
    )
    
    // ReusableView
    @objc optional func collectionView(
        _ collectionView: UICollectionView,
        supplementaryElementOfKind kind: String,
        firstTimeOfFullyVisibleItems items: [IndexPath]
    )
    
    @objc optional func collectionView(
        _ collectionView: UICollectionView,
        supplementaryElementOfKind kind: String,
        allOfFullyVisibleItems items: [IndexPath]
    )
    
    // Infinite
    @objc optional func collectionView(
        _ collectionView: UICollectionView,
        infinityOfFullyVisibleItems items: [IndexPath]
    )

    @objc optional func collectionView(
        _ collectionView: UICollectionView,
        supplementaryElementOfKind kind: String,
        infinityOfFullyVisibleItems items: [IndexPath]
    )

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

open class VisibilityTrackableCollectionView: UICollectionView, VisibilityTrackableCollectionViewInterface {
    
    /**
     set boundary
          
     It is used as a reference point for determining whether the cell is visible or not.
     
     When not set, the reference point of judgement is divided into two cases:
        
     &nbsp;
     
     If VisibilityTrackableCollectionView is not nested or is the top most
     
        : It determines whether to expose based on the view of the parent ViewController.
     
     &nbsp;
     
     If the VisibilityTrackableCollectionView is nested and has more than two depth
     
        : Find the boundary of the parent VisibilityTrackableCollectionView to use as its own boundary
     
     - parameter boundary: Boundary to use to determine whether a cell is visible

     */
    open func setBoundary(_ boundary: Boundary) {
        boundaryManager.boundary = boundary
    }
    
    /// set Infinite
    ///
    /// Set for infinite scrolling.
    /// If a section is duplicated, infiniteItem and seenData of the existing section are removed.
    ///
    /// - Parameters:
    ///   - infiniteItem: the number of sections and items in the infinite scroll area
    ///   - type: cell, header, footer
    open func setInfiniteScroll(infiniteItem: InfiniteItem, type: VisibilityTrackableViewType) {
        viewModel.setInfiniteScroll(infiniteItem: infiniteItem, type: type)
    }
    
    private(set) lazy var boundaryManager = BoundaryManager(owner: self)

    private var viewModel = ViewModel() {
        didSet { bind() }
    }
    
    private var delegateVisibleItems: CollectionViewDelegateVisibleItems? {
        delegate as? CollectionViewDelegateVisibleItems
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        bind()
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        bind()
    }
    
    open override func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let _ = cell as? InnerVisibilityTrackerInterface {
            viewModel.reloadInner(type: .cell, parent: self, at: indexPath)
        }
        
        return cell
    }
    
    open override func dequeueReusableSupplementaryView(ofKind elementKind: String, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
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
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateFullyVisibleItemsIfNeeded()
    }

    open func configure(viewModel: ViewModel) {
        self.viewModel = viewModel
        updateFullyVisibleItemsIfNeeded()
    }
    
    open func refreshSeenData() {
        viewModel.notiRefreshToAllInners(parent: self)
        viewModel.refreshSeenData()
        updateFullyVisibleItemsIfNeeded()
    }
    
    open func refreshSections(_ sections: [Int]) {
        viewModel.notiRefreshToAllInners(parent: self, sections: sections)
        viewModel.refreshSections(sections)
        updateFullyVisibleItemsIfNeeded()
    }
    
    open func refreshInfiniteItems(type: VisibilityTrackableViewType) {
        viewModel.refreshInfiniteItems(type: type)
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
            case .infinite(let data):
                self.fullyVisibleInfiniteItems(indexPaths: data.indexPaths, type: data.type)
            }
        }
    }
    
    func fullyVisibleAll(indexPaths: [IndexPath], type: VisibilityTrackableViewType) {
        guard indexPaths.isNotEmpty else { return }
        switch type {
        case .cell:
            delegateVisibleItems?.collectionView?(
                self,
                allOfFullyVisibleItems: indexPaths
            )
        case .header:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.header.rawValue,
                allOfFullyVisibleItems: indexPaths
            )
        case .footer:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.footer.rawValue,
                allOfFullyVisibleItems: indexPaths
            )
        }
    }
    
    func fullyVisibleFirstTime(indexPaths: [IndexPath], type: VisibilityTrackableViewType) {
        guard indexPaths.isNotEmpty else { return }
        switch type {
        case .cell:
            delegateVisibleItems?.collectionView?(
                self,
                firstTimeOfFullyVisibleItems: indexPaths
            )
        case .header:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.header.rawValue,
                firstTimeOfFullyVisibleItems: indexPaths
            )
        case .footer:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.footer.rawValue,
                firstTimeOfFullyVisibleItems: indexPaths
            )
        }
    }

    func fullyVisibleInfiniteItems(indexPaths: [IndexPath], type: VisibilityTrackableViewType) {
        guard indexPaths.isNotEmpty else { return }
        switch type {
        case .cell:
            delegateVisibleItems?.collectionView?(
                self,
                infinityOfFullyVisibleItems: indexPaths
            )
        case .header:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.header.rawValue,
                infinityOfFullyVisibleItems: indexPaths
            )
        case .footer:
            delegateVisibleItems?.collectionView?(
                self,
                supplementaryElementOfKind: SectionSupplement.footer.rawValue,
                infinityOfFullyVisibleItems: indexPaths
            )
        }
    }

}
#endif
