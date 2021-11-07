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
        label.text = "$$$ " + "\u{00B7}" + " Restaurant"
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
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .left
        label.text = "Restaurant Name"
        return label
    }()
    
    let favoriteButton : UIButton = {
        let button = UIButton()
        let image = UIImage(named:"favorite")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        button.tintColor = .lightGray
        button.setImage(image, for: .normal)
        //button.isUserInteractionEnabled = true
        //button.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
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
        self.addSubview(self.cellContentView)
        self.cellContentView.addSubview(self.placeImageView)
        self.cellContentView.addSubview(self.restaurantNameLabel)
        self.cellContentView.addSubview(self.ratingView)
        self.cellContentView.addSubview(self.reviewCountLabel)
        self.cellContentView.addSubview(self.priceAndSupportingTextLabel)
        self.favoriteButton.isUserInteractionEnabled = true
        self.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        self.cellContentView.addSubview(self.favoriteButton)
        
        self.makeConstriants()
        
    }
    
    
    
    @objc func favoriteButtonTapped() {
        print("Hello")
        if favoriteButton.image(for: .normal) == UIImage(named: "favorite") {
            let image = UIImage(named:"favoriteFilled")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            favoriteButton.tintColor = ColorUtils.mapButtonColor
            favoriteButton.setImage(image, for: .normal)
        } else {
            let image = UIImage(named:"favorite")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            favoriteButton.tintColor = .lightGray
            favoriteButton.setImage(image, for: .normal)
        }
        
        //favoriteButton.setNeedsDisplay()
    }
    
    func setRating() {
        self.ratingView.setRating(self.rating)
    }
    
    func makeConstriants() {
        self.cellContentView.snp.makeConstraints { maker in
            maker.top.left.right.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview()
        }
        
        self.placeImageView.snp.makeConstraints { maker in
            maker.top.left.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(20)
            maker.width.equalTo(90)
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
            maker.height.equalTo(20)
        }
        
    }
}
