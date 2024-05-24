//
//  AboutViewController.swift
//  mobile 911
//
//  Created by Fernando Cerini on 23/05/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var appInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(navBar)
        navBar.setBackgroundImage(UIImage(named: "ba-banner"), for: .default)
        
        setLabelInfo()
        
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    private func setLabelInfo() {
        let year = Calendar.current.component(.year, from: Date())
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        
        
        
        if let version = UserDefaults.standard.getConfig()?.version {
            self.appInfo.text = "© " + String(year) + " Soflex SA\nVersión: " + (appVersion!) + "\nConfig:  " + version
        } else {
            self.appInfo.text = "© " + String(year) + " Soflex SA\nVersión: " + (appVersion!)
        }
        
        
        
        
        self.appInfo.numberOfLines = 0
        
    }
    
}
