//
//  AllTrailsCell.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import Foundation
import UIKit
import SnapKit

class AllTrailsCell: UITableViewCell {
    static let reuseIdentifier = "AllTrailsCellIdentifiier"
    
    var rating: Int {
        didSet {
            self.setRating()
        }
    }
    
    let cellContentView : UIView = {
        let view = UIView(frame: .zero)
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let placeImageView : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "placeImagePlaceHolder")
        return imageView
    }()
    
    let priceAndSupportingTextLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Restaurant"
        return label
    }()
    
    var ratingView : RatingView = RatingView(frame: .zero, rating: 0)
    
    let reviewCountLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "(135)"
        return label
    }()
    
    let restaurantNameLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .left
        label.text = "Restaurant Name"
        return label
    }()
    
    let favoriteButton : UIButton = {
        let button = UIButton(frame: .zero)
        let image = UIImage(named:"favorite")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        return button
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.rating = 0
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.selectionStyle = .none
        self.contentView.addSubview(cellContentView)
        self.cellContentView.addSubview(self.placeImageView)
        self.cellContentView.addSubview(self.restaurantNameLabel)
        self.cellContentView.addSubview(self.ratingView)
        self.cellContentView.addSubview(self.reviewCountLabel)
        self.cellContentView.addSubview(self.priceAndSupportingTextLabel)
        self.cellContentView.addSubview(self.favoriteButton)
        self.makeConstriants()
        //self.bringSubviewToFront(cellContentView)
    }
    
    func setRating() {
        self.ratingView.setRating(self.rating)
    }
    
    func makeConstriants() {
        self.contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        self.cellContentView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview().inset(20).priority(999)
            maker.bottom.equalToSuperview()
        }
        
        self.placeImageView.snp.makeConstraints { maker in
            maker.top.left.bottom.equalToSuperview().inset(20)
            maker.width.equalTo(self.placeImageView.snp.height)
        }
        
        self.ratingView.snp.makeConstraints { maker in
            maker.left.equalTo(self.placeImageView.snp.right).offset(20)
            maker.width.equalTo(120)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(24)
        }
        
        self.reviewCountLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.ratingView.snp.right).offset(5)
            maker.right.equalToSuperview().offset(-15)
            maker.centerY.equalTo(self.ratingView)
            maker.height.equalTo(20)
        }
                        
        self.priceAndSupportingTextLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.placeImageView.snp.right).offset(20)
            maker.right.equalToSuperview().offset(-15)
            maker.top.equalTo(self.ratingView.snp.bottom).offset(5)
            maker.height.equalTo(20)
        }

        self.favoriteButton.snp.makeConstraints { maker in
            maker.height.width.equalTo(30)
            maker.top.equalToSuperview().offset(20)
            maker.right.equalToSuperview().offset(-15)
        }
                
        self.restaurantNameLabel.snp.makeConstraints { maker in
            maker.left.equalTo(self.placeImageView.snp.right).offset(20)
            maker.right.equalTo(self.favoriteButton.snp.left).offset(-5)
            maker.bottom.equalTo(self.ratingView.snp.top).offset(-5)
            maker.height.greaterThanOrEqualTo(20)
        }
        
    }
}
