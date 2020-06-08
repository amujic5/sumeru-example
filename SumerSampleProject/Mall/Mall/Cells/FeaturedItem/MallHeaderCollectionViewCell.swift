//
//  MallHeaderCollectionViewCell.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 08/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
import Kingfisher

class MallHeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var items: [FeaturedItem] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.register(cell: MallFeaturedItemCollectionViewCell.self)
        collectionView.delegate = self
    }
    
    func updateUI(items: [FeaturedItem]) {
        self.items = items
        collectionView.reloadData()
        pageControl.numberOfPages = items.count
    }

}

extension MallHeaderCollectionViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MallFeaturedItemCollectionViewCell = collectionView.dequeueCellAtIndexPath(indexPath: indexPath)
        let item = items[indexPath.row]
        cell.itemImageView.image = nil
        cell.itemImageView.kf.setImage(with: item.imageUrl?.toUrl)
        
        return cell
    }
    
}


// MARK: - UICollectionViewDelegateFlowLayout
extension MallHeaderCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPading: CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 10
        var width = collectionView.frame.width
        width = (width -  cellPading)
        
        return CGSize(width: width, height: collectionView.frame.height)
    }
    
}


// MARK: - UIScrollViewDelegate
extension MallHeaderCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(Float(scrollView.contentOffset.x / scrollView.frame.width).rounded())
    }
    
}
