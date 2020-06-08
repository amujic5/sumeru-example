//
//  MallViewController.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 04/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit
        
class MallViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var mall: Mall?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(cell: MallHeaderCollectionViewCell.self)
        collectionView.register(cell: MallCategoryItemCollectionViewCell.self)
        collectionView.register(cell: MallStoreItemCollectionViewCell.self)
        collectionView.register(UINib(nibName: MallSectionHeaderCollectionReusableView.identity, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MallSectionHeaderCollectionReusableView.identity)
        
        MallService
            .shared
            .getMall(forceRefresh: false, success: { (mall) in
                self.mall = mall
                self.collectionView.reloadData()
            }) { (error) in
                // todo show error
        }
    }
}

// MARK: - UICollectionViewDataSource
extension MallViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let mall = mall {
            return mall.categories.count + 2
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mall = mall else { return 0 }
        
        if section == 0 {
            return 1
        } else if section == 1 {
            return mall.categories.count
        } else {
            return mall.categories[section - 2].stores.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let mall = mall else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            let cell: MallHeaderCollectionViewCell = collectionView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.updateUI(items: mall.featuredItems)
            
            return cell
        }
        
        if indexPath.section == 1 {
            let category = mall.categories[indexPath.row]
            let cell: MallCategoryItemCollectionViewCell = collectionView.dequeueCellAtIndexPath(indexPath: indexPath)
            cell.updateUI(category: category)
            
            return cell
        }
        
        let store = mall.categories[indexPath.section - 2].stores[indexPath.row]
        let cell: MallStoreItemCollectionViewCell = collectionView.dequeueCellAtIndexPath(indexPath: indexPath)
        cell.updateUI(store: store)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MallSectionHeaderCollectionReusableView.identity, for: indexPath) as! MallSectionHeaderCollectionReusableView
        
        if indexPath.section == 1 {
            view.titleLabel.text = "Categories"
        } else if indexPath.section > 1 {
            view.titleLabel.text = mall?.categories[indexPath.section - 2].name
        }
        
        return view
    }
    
}

// MARK: - UICollectionViewDelegate
extension MallViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mall = mall else { return }
        if indexPath.section == 1 {
            let category = mall.categories[indexPath.row]
            navigationController?.pushViewController(MallCategoryViewController(category: category), animated: true)
        } else if indexPath.section > 1 {
            let store = mall.categories[indexPath.section - 2].stores[indexPath.row]
            navigationController?.pushViewController(WebViewController(urlString: store.storeUrl), animated: true)
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension MallViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPading: CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 10
        let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width - sectionInset.left - sectionInset.right, height: 300)
        }

        var width = collectionView.frame.width
        width = (width - 2 * cellPading - sectionInset.left - sectionInset.right) / 3
        
        return CGSize(width: width, height: width + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? .zero : CGSize(width: collectionView.frame.width, height: 50)
    }
    
}
