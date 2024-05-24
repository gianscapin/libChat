//
//  CredencialesViewController.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 13/05/2024.
//  Copyright © 2024 Soflex. All rights reserved.
//

import UIKit
import RxSwift


class CredencialesViewController: UIViewController {


//   @IBOutlet weak var usuario: UITextField!
////
//   @IBOutlet weak var password: UITextField!
////
//   @IBOutlet weak var btnAcceder: UIButton!
    
    
    
    @IBOutlet weak var usuario: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var btnAcceder: UIButton!
    
   override func viewDidLoad() {
       super.viewDidLoad()


       // Do any additional setup after loading the view.
      
      
      
       //UserDefaults.standard.getConfig()!.credencial
      
       // Desactiva Autoresizing Mask
       usuario.translatesAutoresizingMaskIntoConstraints = false
       password.translatesAutoresizingMaskIntoConstraints = false
       btnAcceder.translatesAutoresizingMaskIntoConstraints = false
       
    
       // Añade los elementos al ViewController
       view.addSubview(usuario)
       view.addSubview(password)
       view.addSubview(btnAcceder)

       // Añade constraints
       NSLayoutConstraint.activate([
           // Constraints para userTextField
            usuario.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            usuario.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            usuario.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64),

           // Constraints para passwordTextField
            password.leadingAnchor.constraint(equalTo: usuario.leadingAnchor),
            password.trailingAnchor.constraint(equalTo: usuario.trailingAnchor),
            password.topAnchor.constraint(equalTo: usuario.bottomAnchor, constant: 16),

           // Constraints para loginButton
            btnAcceder.leadingAnchor.constraint(equalTo: usuario.leadingAnchor),
            btnAcceder.trailingAnchor.constraint(equalTo: usuario.trailingAnchor),
            btnAcceder.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 16)
       ])
      
      
   }
   @IBAction func onAccederClickButton(_ sender: Any) {
      
       let username = usuario.text ?? ""
       let password = password.text ?? ""
      
      
      
       self.login(usuario: username, password: password)
      
      
      
   }
  
   @IBAction func onBackClickButton(_ sender: Any) {
      
       dismiss(animated: true, completion: nil)
   }
  
  
   private func login(usuario: String, password: String) {
      
       let json = GetCredenciales(method: "getCredenciales", data: Credenciales(user: usuario, pass: password))
      
      
       guard let uploadData = try? JSONEncoder().encode(json) else {
           return
       }
      
       ApiHelper2<RespuestaCredencial>().post(url: Constants.API_URL + "usuario.php", body: uploadData).subscribe(onNext: { credencial in
               if(credencial.result == "OK") {
                   print(credencial.output!.codigo_gps)
                   UserDataHelper.setImei(imei: credencial.output!.codigo_gps)
                  
                  
                   UserDataHelper.isRegistrado().subscribe(onNext: { registro in
                       if registro {
                           DispatchQueue.main.async {
                               let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                               let viewController = storyBoard.instantiateViewController(withIdentifier: "mapa") as! ViewController
                               viewController.modalPresentationStyle = .fullScreen
                               let navigationController = UINavigationController(rootViewController:  viewController)
                               navigationController.modalPresentationStyle = .fullScreen
                               self.present(navigationController, animated: true, completion: nil)
                           }
                          
                       } else {
                           DispatchQueue.main.async {
                               self.showAlertMessage(title: "Atencion", message: "El usuario ingresado esta deshabilitado")
                           }
                       }
                   })
                  
                  
               } else {
                   DispatchQueue.main.async {
                       self.showAlertMessage(title: "Atencion", message: "Usuario y contraseña incorrecto")
                   }
               }
       }, onError: { [self] error in
           DispatchQueue.main.async {
               self.showAlertMessage(title: "Atencion", message: "Ocurrio un error, intente nuevamente")
           }
          
       })
   }
  
  
   func showAlertMessage(title: String, message: String) {
       let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
       let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
       alertController.addAction(okAction)
      
       present(alertController, animated: true, completion: nil)
   }
}
