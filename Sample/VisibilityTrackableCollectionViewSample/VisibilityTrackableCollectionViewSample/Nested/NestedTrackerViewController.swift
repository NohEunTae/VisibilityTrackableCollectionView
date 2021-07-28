//
//  NestedTrackerViewController.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit
import VisibilityTrackableCollectionView
import SnapKit

final class NestedTrackerViewController: UIViewController {

    private let collectionView: VisibilityTrackableCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return VisibilityTrackableCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
    }()
    
    private let adapter = NestedCollectionViewApater()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        adapter.setRequirements(collectionView: collectionView)
        collectionView.setBoundary(.init(view: attachTargetView()))
    }
    
    private func attachTargetView() -> UIView {
        let targetView = UIView()
        view.addSubview(targetView)
        targetView.isUserInteractionEnabled = false
        targetView.backgroundColor = .clear
        targetView.layer.borderWidth = 2
        targetView.layer.borderColor = UIColor.red.cgColor
        targetView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalToSuperview().multipliedBy(0.7)
        }
        return targetView
    }

}
