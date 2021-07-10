//
//  ViewController.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/10.
//

import UIKit
import VisibilityTrackableCollectionView

final class ViewController: UIViewController {

    @IBOutlet private weak var collectionView: VisibilityTrackableCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.setBoundary(.init(view: attachTargetView()))
        collectionView.register(UINib(nibName: "TextCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TextCollectionViewCell.cellIdentifier)
        collectionView.register(UINib(nibName: "DoubleDepthInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: DoubleDepthInnerCollectionViewCell.cellIdentifier)
        collectionView.register(UINib(nibName: "SingleInnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: SingleInnerCollectionViewCell.cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func attachTargetView() -> UIView {
        let targetView = UIView()
        view.addSubview(targetView)
        targetView.translatesAutoresizingMaskIntoConstraints = false
        targetView.isUserInteractionEnabled = false
        targetView.backgroundColor = .clear
        targetView.layer.borderWidth = 2
        targetView.layer.borderColor = UIColor.red.cgColor
        targetView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        targetView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        targetView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        targetView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        return targetView
    }

}

extension ViewController: UICollectionViewDataSource {
    
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Section(rawValue: section)?.numberOfItems ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .normal1, .normal2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.cellIdentifier, for: indexPath) as? TextCollectionViewCell else { return .init() }
            cell.configure("\(indexPath.item)")
            return cell
        case .doubleDepthInner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoubleDepthInnerCollectionViewCell.cellIdentifier, for: indexPath) as? DoubleDepthInnerCollectionViewCell else { return .init() }
            return cell
        case .singleDepthInner:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleInnerCollectionViewCell.cellIdentifier, for: indexPath) as? SingleInnerCollectionViewCell else { return .init() }
            return cell
            
        default:
            return .init()
        }
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
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

extension ViewController: CollectionViewDelegateVisibleItems {
    func collectionView(_ collectionView: UICollectionView, firstTimeOfFullyVisibleItems items: [IndexPath]) {
        print("firstTimeOfFullyVisibleItems: \(items)")
    }
}


