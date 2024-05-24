//
//  TestigoPanico.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 10/07/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import UIKit

@IBDesignable
final class TestigoPanico: UIStackView {
    
    private let image = UIImageView()
    private let label = UILabel()
    private let view = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTestigo()
    }
    
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        createTestigo()
    }
    
    
    private func createTestigo() {
        
        view.layer.cornerRadius = 10
        
        image.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
 
    }
    
    
}
