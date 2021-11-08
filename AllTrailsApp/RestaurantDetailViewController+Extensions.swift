//
//  RestaurantDetailViewController+Extensions.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/8/21.
//

import Foundation
import UIKit


extension RestaurantDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = images[indexPath.row]
        
        return cell
    }
}

extension RestaurantDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableview.dequeueReusableCell(withIdentifier: DetailsCell.reuseIdentifier) as? DetailsCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.cellLabel.text = self.place?.address
            let image = UIImage(named:"map")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            cell.imgView.image = image
        case 1:
            cell.cellLabel.text = self.place?.phoneNumber
            let image = UIImage(named:"phone")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            cell.imgView.image = image
        case 2:
            cell.cellLabel.attributedText = (place?.openingHours?.isOpen ?? false) ? NSAttributedString(string: "Open", attributes: [NSAttributedString.Key.foregroundColor: ColorUtils.mapButtonColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)]) : NSAttributedString(string: "Closed", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12)])
            let image = UIImage(named:"hours")?.withRenderingMode(
                UIImage.RenderingMode.alwaysTemplate)
            cell.imgView.image = image
        default:
            break
        }
        
        cell.imgView.tintColor = ColorUtils.mapButtonColor
        return cell
    }
    
    
}
