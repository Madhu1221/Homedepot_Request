//
//  CustomImageFlowLayout.swift
//  HomeDepot
//
//  Created by Madhu on 3/17/18.
//  Copyright © 2018 Madhu. All rights reserved.
//
import UIKit

class DataFlowLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }

    override var itemSize: CGSize {
        set {
        }
        get {
            let numberOfColumns: CGFloat = 2
            let itemWidth = (self.collectionView!.frame.size.width - 10 - (numberOfColumns - 1)) / numberOfColumns
            return CGSize(width:itemWidth, height:120)
        }
    }


    func setupLayout() {
        minimumInteritemSpacing = 10
        minimumLineSpacing = 10
        scrollDirection = .vertical
    }

}
