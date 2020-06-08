//
//  PaymentsViewController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 22/05/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController {

    var trackingPayments: [TrackingPayment] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PaymentTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentTableViewCell")
        
        TrackingManager.shared.load()
        trackingPayments = TrackingManager.shared.payments.reversed()
        
        tableView.tableFooterView = UIView()
    }

}

extension PaymentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackingPayments.count
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCell", for: indexPath) as! PaymentTableViewCell
        let item = trackingPayments[indexPath.row]
        cell.amountLabel.text = "Amount: \(item.amount)"
        cell.urlLabel.text = "Full url: \(item.urlString)"
        cell.hostLabel.text = "Host: \(item.hostUrl)"
        
        return cell
    }
    
    
}
