//
//  RatingView.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/4/21.
//

import Foundation
import UIKit

class RatingView: UIView {
    
    var stackView: UIStackView = UIStackView(frame: .zero)
    let rating: Int
    init(frame: CGRect, rating: Int) {
        self.rating = rating
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(rating: Int = 0) {
        var views = [UIImageView]()
        
        for _ in 0..<rating {
            let image = UIImage(named:"ratingStarFilled")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = ColorUtils.ratingYellowColor

            views.append(imageView)
        }
        
        for _ in rating..<5 {
            let image = UIImage(named:"ratingStarFilled")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            let imageView = UIImageView(image: image)
            imageView.tintColor = ColorUtils.ratingDefaultColor

            views.append(imageView)
        }

        
        let sv = UIStackView(arrangedSubviews: views)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .equalSpacing
        
        stackView.removeFromSuperview()
        stackView = sv
        self.addSubview(stackView)

        stackView.snp.remakeConstraints { maker in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func setRating(_ rating: Int){
        self.setupViews(rating: rating)
    }
}
