//
//  TerminosCondicionesViewController.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 27/06/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

class TerminosCondicionesViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var texto: UITextView!
    
    @IBOutlet weak var aceptarButton: UIButton!
    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var loadingView: UIView = UIView()
    
    var cargado: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.setBackgroundImage(UIImage(named: "ba-banner"), for: .default)
        
        self.cargarTerminos()
        
    }


    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickAceptar(_ sender: UIButton) {
        if (cargado) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsViewController = storyBoard.instantiateViewController(withIdentifier: "datos") as! SettingsViewController
            self.present(settingsViewController, animated: true, completion: nil)
        } else {
            self.cargarTerminos()
        }
    }
    
    
    private func cargarTerminos() {
        showActivityIndicator()
        TerminosCondicionesService().get()
        .subscribe(onNext: { config in
            self.cargado = true
            self.hideActivityIndicator()
            self.texto.text = config
            self.aceptarButton.setTitle("Aceptar", for: .normal)
        }, onError: { error in
            self.cargado = false
            self.hideActivityIndicator()
            self.texto.text = "Error al obtener los terminos y condiciones. Toca en refrescar para intentar de nuevo"
            self.aceptarButton.setTitle("Refrescar", for: .normal)
        })
    }
    
    
    func showActivityIndicator() {
        DispatchQueue.main.async  {
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0)
            self.loadingView.center = self.view.center
            self.loadingView.backgroundColor = .systemGray
            self.loadingView.alpha = 0.7
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10

            self.spinner = UIActivityIndicatorView(style: .whiteLarge)
            self.spinner.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
            self.spinner.center = CGPoint(x:self.loadingView.bounds.size.width / 2, y:self.loadingView.bounds.size.height / 2)

            self.loadingView.addSubview(self.spinner)
            self.view.addSubview(self.loadingView)
            self.spinner.startAnimating()
        }
    }

    func hideActivityIndicator() {
        DispatchQueue.main.async  {
            self.spinner.stopAnimating()
            self.loadingView.removeFromSuperview()
        }
    }
}
