//
//  TextCollectionViewCell.swift
//  VisibilityTrackableCollectionViewSample
//
//  Created by NohEunTae on 2021/06/25.
//

import UIKit

final class TextCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var labelTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        labelTitle.layer.borderWidth = 1
        labelTitle.layer.borderColor = UIColor.gray.cgColor
    }
    
    func configure(_ title: String) {
        labelTitle.text = title
    }
}
