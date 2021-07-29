//
//  ViewController.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/07/10.
//

import UIKit
import VisibilityTrackableCollectionView

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func testNestedDidClicked(_ sender: UIButton) {
        navigationController?.pushViewController(NestedTrackerViewController(), animated: true)
    }
    
    @IBAction private func testInfiniteDidClicked(_ sender: UIButton) {
        navigationController?.pushViewController(InfiniteScrollViewController(), animated: true)
    }
    
}
