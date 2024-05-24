//
//  ContactosViewController.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 23/02/2023.
//  Copyright © 2023 Soflex. All rights reserved.
//

import UIKit

import Eureka
import Toast_Swift
import MapKit

class ContactosViewController: FormViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(navBar)
        createForm();
        
        navBar.setBackgroundImage(UIImage(named: "ba-banner"), for: .default)
        
    }
    
    @IBAction func saveClick(_ sender: UIBarButtonItem) {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: form.values(), options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String: Any] {
                var contacto = Contacto(dictionary: dictFromJSON)
                UserDefaults.standard.setContacto(contacto: contacto)
            }
            
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func saveBack(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        
    }
    
    func createForm() {
        form +++ Section("") +++ Section("En caso de emergencia, la app va a enviar un mensaje a los numeros que estan definido")
            <<< TextRow("uno"){
                $0.title = "Contacto 1"
                $0.placeholder = "Numero telefonico"
                $0.value = UserDefaults.standard.getContacto()?.uno
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow("dos"){
                $0.title = "Contacto 2"
                $0.placeholder = "Numero telefonico"
                $0.value = UserDefaults.standard.getContacto()?.dos
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow("tres"){
                $0.title = "Contacto 3"
                $0.placeholder = "Numero telefonico"
                $0.value = UserDefaults.standard.getContacto()?.tres
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow("cuatro"){
                $0.title = "Contacto 4"
                $0.placeholder = "Numero telefonico"
                $0.value = UserDefaults.standard.getContacto()?.cuatro
                $0.validationOptions = .validatesOnChange
            }
            <<< TextRow("cinco"){
                $0.title = "Contacto 5"
                $0.placeholder = "Numero telefonico"
                $0.value = UserDefaults.standard.getContacto()?.cinco
                $0.validationOptions = .validatesOnChange
            }
    }
    
    
    
}
