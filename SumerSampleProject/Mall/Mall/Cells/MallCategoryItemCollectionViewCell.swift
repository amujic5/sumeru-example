//
//  MallCategoryItemCollectionViewCell.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 04/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
import Kingfisher

class MallCategoryItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        categoryImageView.layer.cornerRadius = categoryImageView.frame.height/2
        categoryImageView.layer.masksToBounds = true
        categoryImageView.layer.borderColor = UIColor.black.cgColor
        categoryImageView.layer.borderWidth = 1.5
    }
    
    func updateUI(category: Category) {
        self.nameLabel.text = category.name
        self.categoryImageView.image = nil
        self.categoryImageView.kf.setImage(with: category.imageUrl?.toUrl)
        
        layoutIfNeeded()
    }
    
}
