//
//  MallStoreItemCollectionViewCell.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 05/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

class MallStoreItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        storeImageView.layer.masksToBounds = true
        storeImageView.layer.borderColor = UIColor.black.cgColor
        storeImageView.layer.borderWidth = 1.5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateUI(store: Store) {
        self.nameLabel.text = store.name
        
        self.storeImageView.image = nil
        self.storeImageView.kf.setImage(with: store.imageUrl?.toUrl)
        
        self.logoImageView.image = nil
        self.logoImageView.kf.setImage(with: store.logoUrl?.toUrl)
    }
    
}
