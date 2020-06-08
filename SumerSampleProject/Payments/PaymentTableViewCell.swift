//
//  PaymentTableViewCell.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 25/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var hostLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
