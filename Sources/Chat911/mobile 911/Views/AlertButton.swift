//
//  MainButton.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 10/10/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

@IBDesignable
final class AlertButton: UIButton {
    
    var borderWidth: CGFloat = 0
    var borderColor = UIColor.white.cgColor
    var icon: UIImage? = nil
    var texto: String? = nil
    var count: Int = 5
    var timer: Timer? = nil

    
    @IBInspectable var titleText: String? {
        didSet {
            self.setTitle(titleText, for: .normal)
            self.setTitleColor(UIColor.black,for: .normal)
        }
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    
    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderColor = borderColor
        self.layer.borderWidth = borderWidth
        self.contentEdgeInsets = UIEdgeInsets(top: 12.0, left: 12.0, bottom: 12.0, right: 12.0)

    }
    
    
    override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        if (timer !== nil) {
            stopTimer()
            return
        } else {
            self.icon = self.imageView?.image
            self.texto = self.titleLabel!.text
            self.setImage(nil, for: .normal)
            self.setTitle(nil, for: .normal)
            showCountDown()
            startAnimation()
            self.setImage(self.imageWith(name: String(self.count)), for: .normal)
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
                if(self.count > 0) {
                    self.count -= 1
                    self.setImage(self.imageWith(name: String(self.count)), for: .normal)
                } else {
                    self.stopTimer()
                    super.sendAction(action, to: target, for: event)
                }
            }
        }
    }
    
    func showCountDown() {
        self.titleLabel!.font =  UIFont(name: "Helvetica", size: 20)
    }
    
    func startAnimation() {
        DispatchQueue.main.async {
            
            if let element = self.rootView().view(withId: "background") {
                let actualColor = element.layer.backgroundColor
                UIView.animate(withDuration: 0.4, delay: 0.2, options:[UIView.AnimationOptions.repeat, UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.allowUserInteraction], animations: {
                    element.layer.backgroundColor = UIColor().fromHexColor(hex: "#F5B7B1")?.cgColor
                    element.layer.backgroundColor = actualColor
                }, completion: nil)
            }
        }
    }
    
    func nukeAllAnimations() {
        
        
        
        if let element = self.rootView().view(withId: "background") {
            element.subviews.forEach({$0.layer.removeAllAnimations()})
            element.layer.removeAllAnimations()
            element.layoutIfNeeded()
        }
    }
    
    func stopTimer(){
        count = 5
        timer?.invalidate()
        timer = nil
        nukeAllAnimations()
        restartButton()
    }
    
    func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 80)
        nameLabel.text = name
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    func restartButton() {
        self.setImage(self.icon, for: .normal)
        self.setTitle(self.texto, for: .normal)
    }
}
