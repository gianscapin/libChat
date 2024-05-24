//
//  TestigoControl.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 22/10/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

@IBDesignable
final class TestigoControl: UIStackView {
    
    private let image = UIImageView()
    private let label = UILabel()
    private let view = UIView()
    
//    @IBInspectable var starCount: Int = 5
    

    
    @IBInspectable var side: String? {
        didSet {
            if(side == "left") {
                setBorder(masked: [.layerMaxXMaxYCorner])
            } else {
                setBorder(masked: [.layerMinXMaxYCorner])
            }
        }
    }
    
    private func setBorder(masked: CACornerMask) {
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = masked
    }
    
    func setTestigo(testigo: Testigo) {
        DispatchQueue.main.async {
            self.label.text = testigo.texto
            self.image.image = testigo.icon.imageWithInsets(insets: UIEdgeInsets(top: 200,left: 200,bottom: 200,right: 200))
            
            self.view.backgroundColor = testigo.color
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        createTestigo()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createTestigo()
    }

    private func createTestigo() {
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
                
        image.widthAnchor.constraint(equalToConstant: 50).isActive = true
        label.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        label.textAlignment = .center;
        
        self.isLayoutMarginsRelativeArrangement = true

        label.text = "--"
        label.textColor = .black
        
        image.image = UIImage(named:"nada")?.imageWithInsets(insets: UIEdgeInsets(top: 200,left: 200,bottom: 200,right: 200))
        
        
     
        
        view.backgroundColor = UIColor().fromHexColor(hex: "#A9A9A9")!
        
        view.addSubview(image)
        view.addSubview(label)
        
        
        self.addSubview(view)
        
        
        // Image
        let imageLeading = NSLayoutConstraint(item: image, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        
        let imageTop = NSLayoutConstraint(item: image, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        let imageBottom = NSLayoutConstraint(item: image, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        
        // Label
        let labelTrailing = NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal
            , toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let labelBottom = NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal
            , toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let labelTop = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal
            , toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        
        // View
        let viewTrailing = NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal
            , toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        let viewBottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal
            , toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        let viewTop = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal
            , toItem: self, attribute: .top, multiplier: 1, constant: 0)
        
        let viewLeading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)

        
        NSLayoutConstraint.activate([ viewTrailing, viewBottom, viewTop, viewLeading,  imageLeading, imageTop, imageBottom, labelTrailing, labelBottom, labelTop ])
    
//        NSLayoutConstraint.activate([])
        
        
        
        

    }
    
    
}
