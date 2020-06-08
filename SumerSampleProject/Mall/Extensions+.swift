//
//  UIView+.swift
//  SumerSampleProject
//
//  Created by Azzaro Mujic on 04/06/2020.
//  Copyright © 2020 Azzaro Mujic. All rights reserved.
//

import UIKit

extension UIView {
    
    static var identity: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identity, bundle: nil)
    }
    
}


extension UICollectionView {
    
    func dequeueCellAtIndexPath<T: UICollectionViewCell>(indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withReuseIdentifier: T.identity, for: indexPath) as? T {
            return cell
        } else {
            fatalError("cell with \"\(T.identity)\" identifier is not registered!")
        }
    }
    
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.identity)
    }
    
}


extension UITableView {
    
    func dequeueCellAtIndexPath<T: UITableViewCell>(indexPath: IndexPath) -> T {
        if let cell = dequeueReusableCell(withIdentifier: T.identity, for: indexPath) as? T {
            return cell
        } else {
            fatalError("cell with \"\(T.identity)\" identifier is not registered!")
        }
    }
    
    func register<T: UITableViewCell>(cell: T.Type) {
        register(T.nib, forCellReuseIdentifier: T.identity)
    }
    
}

extension String {
    
    var toUrl: URL? {
        return URL(string: self)
    }
    
}
