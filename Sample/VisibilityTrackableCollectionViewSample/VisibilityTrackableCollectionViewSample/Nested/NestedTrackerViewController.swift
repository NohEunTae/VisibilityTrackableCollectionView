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
    
    private let refreshSectionButton = UIButton()
    private let refreshSeenDataButton = UIButton()
    private lazy var buttonContainer = UIStackView(arrangedSubviews: [refreshSeenDataButton, refreshSectionButton])

    private let adapter = NestedCollectionViewApater()
    
    private let normal1Section = NestedCollectionViewApater.Section.normal1.rawValue
    private let normal2Section = NestedCollectionViewApater.Section.normal2.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
        
    @objc
    private func reloadButtonDidClicked(_ sender: UIButton) {
        collectionView.refreshSeenData()
    }

    @objc
    private func reloadSectionButtonDidClicked(_ sender: UIButton) {
        collectionView.refreshSections([normal1Section, normal2Section])
    }
}

// MARK:- UI
private extension NestedTrackerViewController {
    
    func setupView() {
        setupCollectionView()
        setupButtonContainer()
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        adapter.setRequirements(collectionView: collectionView)
        collectionView.setBoundary(.init(view: attachTargetView()))
    }
    
    func setupButtonContainer() {
        view.addSubview(buttonContainer)
        buttonContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().priority(.low)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        [refreshSeenDataButton, refreshSectionButton].forEach { button in
            button.snp.makeConstraints {
                $0.width.equalTo(170)
            }
        }
        
        buttonContainer.spacing = 10
        buttonContainer.axis = .horizontal

        setupRefreshSeenDataButton()
        setupRefreshSectionButton()
    }
    
    func setupRefreshSeenDataButton() {
        refreshSeenDataButton.setTitle("refresh seen data", for: .normal)
        refreshSeenDataButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        refreshSeenDataButton.backgroundColor = .darkGray.withAlphaComponent(0.7)
        refreshSeenDataButton.clipsToBounds = true
        refreshSeenDataButton.layer.cornerRadius = 10
        refreshSeenDataButton.addTarget(self, action: #selector(reloadButtonDidClicked(_:)), for: .touchUpInside)
    }
    
    func setupRefreshSectionButton() {
        refreshSectionButton.setTitle("refresh sections \(normal1Section), \(normal2Section)", for: .normal)
        refreshSectionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        refreshSectionButton.backgroundColor = .darkGray.withAlphaComponent(0.7)
        refreshSectionButton.clipsToBounds = true
        refreshSectionButton.layer.cornerRadius = 10
        refreshSectionButton.addTarget(self, action: #selector(reloadSectionButtonDidClicked(_:)), for: .touchUpInside)
    }
    
    func attachTargetView() -> UIView {
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
