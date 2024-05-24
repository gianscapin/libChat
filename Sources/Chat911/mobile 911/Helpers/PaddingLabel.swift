//
//  PaddingLabel.swift
//  mobile 911
//
//  Created by Fernando Cerini on 14/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//
import UIKit

@IBDesignable class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 7.0
    @IBInspectable var rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
        
        super.numberOfLines = 0
        super.lineBreakMode = .byWordWrapping
        super.textColor = UIColor.black
        super.layer.cornerRadius = 12
        super.layer.masksToBounds = true
        super.layer.borderColor = UIColor.lightGray.cgColor
        super.layer.borderWidth = 1
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}
