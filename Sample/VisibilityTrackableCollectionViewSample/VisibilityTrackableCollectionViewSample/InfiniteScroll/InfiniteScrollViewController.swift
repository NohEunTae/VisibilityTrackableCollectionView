//
//  InfiniteScrollViewController.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/28.
//

import UIKit
import VisibilityTrackableCollectionView

final class InfiniteScrollViewController: UIViewController {

    private let collectionView: VisibilityTrackableCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return VisibilityTrackableCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
    }()
    
    private let remainTimeLabel = UILabel()

    private let adapter = InfiniteScrollAdapter()
        
    private let maxTime = 5
    private lazy var remainTime = maxTime
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        invalidateTimer()
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.centerY.equalToSuperview()
            $0.height.equalTo(300)
        }
        adapter.setRequirements(collectionView: collectionView, numberOfItems: 10)
        
        view.addSubview(remainTimeLabel)
        remainTimeLabel.snp.makeConstraints {
            $0.size.equalTo(100)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
                
        remainTimeLabel.backgroundColor = .darkGray.withAlphaComponent(0.7)
        remainTimeLabel.clipsToBounds = true
        remainTimeLabel.layer.cornerRadius = 10
        remainTimeLabel.textColor = .white
        remainTimeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.text = "\(remainTime)"
    }

    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer(fire: Date(), interval: 1, repeats: true, block: { [weak self] timer in
            self?.handleTimer(timer)
        })
        
        RunLoop.main.add(timer!, forMode: .common)
    }
        
    private func handleTimer(_ timer: Timer) {
        remainTime -= 1
        
        if remainTime < 0 {
            remainTime = maxTime
            
            adapter.setRequirements(collectionView: collectionView, numberOfItems: 30)
            collectionView.setContentOffset(.zero, animated: false)
            collectionView.reloadData()
        }
        
        remainTimeLabel.text = "\(remainTime)"
    }
}
