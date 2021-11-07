//
//  RestaurantDetailViewController.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/6/21.
//

import Foundation
import UIKit
import SnapKit

class RestaurantDetailViewController: UIViewController {
    var place: Place? {
        didSet{
            self.restaurantNameLabel.text = place?.name
            self.ratingView.setRating(Int(place?.rating ?? 0))
            let st = (place?.ratingString ?? "")
            self.priceAndSupportingTextLabel.text = (st.count > 0) ?  (st + " \u{00B7}" + " Restaurant") : "Restaurant"
            self.hoursLabel.attributedText = (place?.openingHours?.isOpen ?? false) ? NSAttributedString(string: "Open", attributes: [NSAttributedString.Key.foregroundColor: ColorUtils.mapButtonColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]) : NSAttributedString(string: "Closed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            self.reviewCountLabel.text = "(\(place?.userRating ?? 0))"
        }
    }
    
    
    var images = [Int]()
    var backButton: UIButton = {
        let leftButton = UIButton(frame: .zero)
        leftButton.setImage(UIImage(named: "backArrow"), for: .normal)
        leftButton.addTarget(self, action: #selector(dissmissDetailsVC), for: .touchUpInside)
        return leftButton
    }()
    var restaurantNameLabel : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .left
        label.text = "Restaurant Name"
        return label
    }()
    var ratingView: RatingView = RatingView(frame: .zero, rating: 0)
    var reviewCountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "(135)"
        return label
    }()
    var priceAndSupportingTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .lightGray
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "$$$ " + "\u{00B7}" + " Restaurant"
        return label
    }()
    var hoursLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "Open", attributes: [NSAttributedString.Key.foregroundColor: ColorUtils.mapButtonColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
        return label
    }()
    
    var imagesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 180, height: 180)
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() {
        
        self.imagesCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        self.imagesCollectionView.dataSource = self
        self.imagesCollectionView.delegate = self
        self.imagesCollectionView.alwaysBounceHorizontal = true
        self.imagesCollectionView.backgroundColor = .black
        self.imagesCollectionView.showsVerticalScrollIndicator = false
        //self.imagesCollectionView.layout.scrollDirection = .horizontal
        
        self.view.addSubview(backButton)
        self.view.addSubview(self.restaurantNameLabel)
        self.view.addSubview(self.ratingView)
        self.view.addSubview(self.reviewCountLabel)
        self.view.addSubview(self.priceAndSupportingTextLabel)
        self.view.addSubview(self.hoursLabel)
        self.view.addSubview(self.imagesCollectionView)
    
        self.backButton.snp.makeConstraints { maker in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            maker.height.width.equalTo(30)
            maker.left.equalToSuperview().offset(10)
        }
        
        self.restaurantNameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.backButton.snp.bottom).offset(10)
            maker.left.equalToSuperview().offset(20)
            maker.height.equalTo(20)
            maker.right.equalToSuperview().inset(50)

        }
        
        self.ratingView.snp.makeConstraints { maker in
            maker.top.equalTo(self.restaurantNameLabel.snp.bottom).offset(2)
            maker.left.equalTo(self.restaurantNameLabel)
            maker.width.equalTo(120)
            maker.height.equalTo(24)
        }
        
        self.reviewCountLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.ratingView)
            maker.left.equalTo(self.ratingView.snp.right).offset(5)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(20)
        }
                        
        self.priceAndSupportingTextLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.ratingView.snp.bottom).offset(2)
            maker.left.equalTo(self.restaurantNameLabel)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(20)
        }

        self.hoursLabel.snp.makeConstraints { maker in
            maker.top.equalTo(self.priceAndSupportingTextLabel.snp.bottom).offset(2)
            maker.left.equalTo(self.restaurantNameLabel)
            maker.height.equalTo(20)
            maker.width.equalTo(self.restaurantNameLabel)
            
        }
        
        self.imagesCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(hoursLabel.snp.bottom).offset(5)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(200)
        }

        
    }
    
    @objc func dissmissDetailsVC() {
        self.dismiss(animated: true, completion: nil)
    }
}


extension RestaurantDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            print("Returning UICollectionViewCell")
            return UICollectionViewCell()
        }

        cell.imageView.image = UIImage(named: "placeImagePlaceHolder")
        
        return cell
    }
}


