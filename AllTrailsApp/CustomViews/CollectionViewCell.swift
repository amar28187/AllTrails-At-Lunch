//
//  CollectionViewCell.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/6/21.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CollectionViewCell"
    var imageView: UIImageView = UIImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
}
