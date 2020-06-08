//
//  MallCategoryViewController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 08/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
import Kingfisher

class MallCategoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.width * 2 / 3))
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let category: Category
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cell: StoreItemTableViewCell.self)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
        if let url = category.imageUrl?.toUrl {
            tableView.tableHeaderView = headerImageView
            headerImageView.kf.setImage(with: url)            
        }
    }

}


// MARK: - UITableViewDataSource
extension MallCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.stores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoreItemTableViewCell = tableView.dequeueCellAtIndexPath(indexPath: indexPath)
        cell.updateUI(store: category.stores[indexPath.row])
        cell.delegate = self
        
        if indexPath.row == 0 {
            cell.topContainerConstraint.constant = 0
        } else {
            cell.topContainerConstraint.constant = -2
        }
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension MallCategoryViewController: UITableViewDelegate {
    
}

// MARK: - StoreItemTableViewCellDelegate
extension MallCategoryViewController: StoreItemTableViewCellDelegate {
    
    func didTapShowButton(in cell: StoreItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let store = category.stores[indexPath.row]
        navigationController?.pushViewController(WebViewController(urlString: store.storeUrl), animated: true)
    }
    
}
