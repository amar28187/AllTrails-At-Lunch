//
//  AnnotationView.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/7/21.
//

import Foundation
import UIKit
import MapKit

class AnnotationView: UIView {
    var rating: Int {
        didSet {
            self.setRating()
        }
    }
    
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
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .left
        label.text = "Restaurant Name"
        return label
    }()
    
//    let favoriteButton : UIButton = {
//        let button = UIButton()
//
//        button.tintColor = .lightGray
//        button.setImage(image, for: .normal)
//        return button
//    }()
    
    let favoriteButton : UIImageView = {
        let imageView = UIImageView(frame: .zero)
        let image = UIImage(named:"favorite")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    override init(frame: CGRect) {
        self.rating = 0
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupViews() {
        self.addSubview(self.placeImageView)
        self.addSubview(self.restaurantNameLabel)
        self.addSubview(self.ratingView)
        self.addSubview(self.reviewCountLabel)
        self.addSubview(self.priceAndSupportingTextLabel)
        self.isUserInteractionEnabled = true
        self.addSubview(self.favoriteButton)
        
        self.makeConstriants()
        
    }
    
    func setRating() {
        self.ratingView.setRating(self.rating)
    }
    
    func makeConstriants() {
        
        self.placeImageView.snp.makeConstraints { maker in
            maker.top.left.bottom.equalToSuperview().inset(10)
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
            maker.top.equalTo(self.placeImageView)
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


class MapMarkerView: MKAnnotationView {
    static let reuseIdentifier = "MapMarkerViewIdentifier"
    
    var annotationView = AnnotationView(frame: .zero)
    var mapPointAnnotation: MapPointAnnotation?
    
    var isFavorite: Bool = false {
        didSet{
            if isFavorite {
                self.annotationView.favoriteButton.image = UIImage(named:"favoriteFilled")?.withRenderingMode(
                    UIImage.RenderingMode.alwaysTemplate)
                self.annotationView.favoriteButton.tintColor = ColorUtils.mapButtonColor
            } else {
                self.annotationView.favoriteButton.image = UIImage(named:"favorite")?.withRenderingMode(
                    UIImage.RenderingMode.alwaysTemplate)
                self.annotationView.favoriteButton.tintColor = .lightGray
            }
        }
    }
//    
//    var title: String = "" {
//        didSet{
//            self.annotationView.restaurantNameLabel.text = title
//        }
//    }
//    
//    var priceText: String = "" {
//        didSet{
//            self.annotationView.priceAndSupportingTextLabel.text = priceText
//        }
//    }
//    
//    var placeImage: UIImage = UIImage(named: "placeImagePlaceHolder")! {
//        didSet{
//            self.annotationView.placeImageView.image = placeImage
//        }
//    }
//    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    func setupViews() {        
        self.detailCalloutAccessoryView = self.annotationView
        self.canShowCallout = true
        self.annotationView.snp.makeConstraints { maker in
            maker.height.equalTo(150)
            maker.width.equalTo(UIScreen.main.bounds.width - 75)
        }
    }
}
