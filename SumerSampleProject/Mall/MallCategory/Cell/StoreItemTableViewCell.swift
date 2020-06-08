//
//  StoreItemTableViewCell.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 08/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

protocol StoreItemTableViewCellDelegate: class {
    func didTapShowButton(in cell: StoreItemTableViewCell)
}

class StoreItemTableViewCell: UITableViewCell {

    weak var delegate: StoreItemTableViewCellDelegate?
    
    @IBOutlet weak var topContainerConstraint: NSLayoutConstraint!
    @IBOutlet weak var storeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var shopNowButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    func updateUI(store: Store) {
        storeImageView.kf.setImage(with: store.imageUrl?.toUrl)
        titleLabel.text = store.name
        descriptionLabel.text = store.description
        
        shopNowButton.layer.borderWidth = 1
        shopNowButton.layer.borderColor = UIColor.black.cgColor
        shopNowButton.layer.cornerRadius = 4
        shopNowButton.layer.masksToBounds = true
        
        containerView.layer.borderWidth = 1.5
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.masksToBounds = true
    }
    
    // MARK: - Action
    @IBAction func didTapShopNowButton(_ sender: Any) {
        delegate?.didTapShowButton(in: self)
    }
}
