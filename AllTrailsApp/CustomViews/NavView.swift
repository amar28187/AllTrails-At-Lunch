//
//  NavView.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import UIKit
import Foundation

class NavView: UIView {
    let filterButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setAttributedTitle(NSAttributedString(
                                    string: "Filter",
                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold)]), for: .normal)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 10
        return button
    }()
    
    let textField : UITextField = {
        let tf = TextField()
        tf.attributedPlaceholder = NSAttributedString(
            string: "Search for a restaurant",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        tf.layer.borderWidth = 0.5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.cornerRadius = 10
        let button = UIButton(type: .custom)
        let image = UIImage(named:"search")?.withRenderingMode(
            UIImage.RenderingMode.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(tf.frame.size.width - 25), y: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(search), for: .touchUpInside)
        button.tintColor = ColorUtils.mapButtonColor
        tf.rightView = button
        tf.rightViewMode = .always
        return tf
    }()
    
    let label1 : UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray
        
        let mut = NSMutableAttributedString()
        mut.append(NSAttributedString(string: "AllTrails", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]))
        mut.append(NSAttributedString(string: " at Lunch", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25, weight: .light)]))
        label.attributedText = mut
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.setupViews()
    }
    
    func setupViews() {
        self.addSubview(label1)
        self.addSubview(filterButton)
        self.addSubview(textField)
        self.textField.delegate = self
        self.label1.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(30)
            maker.top.equalToSuperview().offset(50)
            
        }
        
        self.filterButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().offset(20)
            maker.top.equalTo(label1.snp.bottom).offset(20)
            maker.width.equalTo(75)
            maker.height.equalTo(40)
        }
        
        self.textField.snp.makeConstraints { maker in
            maker.top.equalTo(self.filterButton)
            maker.left.equalTo(self.filterButton.snp.right).offset(15)
            maker.height.equalTo(self.filterButton)
            maker.right.equalToSuperview().inset(20)
        }
    }
    
    @objc func search() {
        print(String(describing: self.textField.text))
    }
}

extension NavView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.placeholder = ""
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
