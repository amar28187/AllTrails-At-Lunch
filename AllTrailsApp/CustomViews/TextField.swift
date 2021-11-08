//
//  TextField.swift
//  AllTrailsApp
//
//  Created by Amar Makana on 11/2/21.
//

import UIKit
import Foundation

class TextField: UITextField {
    let insetX: CGFloat = 20
    let insetY: CGFloat = 10

    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
