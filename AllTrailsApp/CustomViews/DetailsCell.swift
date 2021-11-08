//
//  DetailsCell.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import UIKit
import SnapKit

class DetailsCell: UITableViewCell {
    
    static let reuseIdentifier = "DetailsCellId"
    
    let imgView: UIImageView  = UIImageView(frame: .zero)
    let cellLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(self.imgView)
        self.addSubview(self.cellLabel)
        
        self.imgView.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(20)
            maker.height.width.equalTo(30)
            maker.centerY.equalToSuperview()
        }
        
        self.cellLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.imgView.snp.right).offset(20)
            maker.right.equalToSuperview().inset(20)
            maker.height.greaterThanOrEqualTo(20)
            maker.centerY.equalToSuperview()
        }
    }
}
