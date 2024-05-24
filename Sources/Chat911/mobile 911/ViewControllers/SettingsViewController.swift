//
//  Settings.swift
//  mobile 911
//
//  Created by Fernando Cerini on 02/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit
import Eureka
import Toast_Swift
import MapKit

class SettingsViewController: FormViewController {
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    var locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(navBar)
        createForm();
        
        navBar.setBackgroundImage(UIImage(named: "ba-banner"), for: .default)
        
        
        
        if (UserDefaults.standard.getUsuario()?.firstName != nil) {
            navItem.rightBarButtonItem = nil;
        }
        
        

        
    }
    
    func createForm() {
        let formularioAcotado = UserDefaults.standard.getConfig()?.formularioAcotado ?? false;
        
        
        
        
        
        form +++ Section("") +++ Section("")
            
            <<< TextRow("firstName"){
                $0.title = "Nombres"
                $0.placeholder = "Obligatorio"
                $0.value = UserDefaults.standard.getUsuario()?.firstName
                $0.disabled = UserDefaults.standard.getUsuario()?.firstName != nil ? true : false
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
               
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            
            <<< TextRow("lastName"){
                $0.title = "Apellidos"
                $0.placeholder = "Obligatorio"
                $0.value = UserDefaults.standard.getUsuario()?.lastName
                $0.disabled = UserDefaults.standard.getUsuario()?.lastName != nil ? true : false
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            
            <<< ActionSheetRow<String>("sex") {
                $0.title = "Sexo"
                $0.selectorTitle = "Sexo"
                $0.options = ["FEMENINO","MASCULINO"]
                $0.value = UserDefaults.standard.getUsuario()?.sex != nil ? UserDefaults.standard.getUsuario()?.sex: "FEMENINO"
                $0.disabled = UserDefaults.standard.getUsuario()?.sex != nil ? true : false
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.textLabel? .textColor = .red
                }
            }
            
            
            <<< ActionSheetRow<String>("docType") {
                $0.title = "Tipo Doc"
                $0.selectorTitle = "Tipo de documento"
                $0.options = ["DNI","PAS"]
                $0.value =  UserDefaults.standard.getUsuario()?.docType != nil ? UserDefaults.standard.getUsuario()?.docType: "DNI"
                $0.disabled = UserDefaults.standard.getUsuario()?.docType != nil ? true : false
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.textLabel? .textColor = .red
                }
            }
            
            
            
            <<< PhoneRow("docNumber"){
                $0.title = "Documento"
                $0.placeholder = "Obligatorio"
                $0.value = UserDefaults.standard.getUsuario()?.docNumber
                $0.add(rule: RuleRequired())
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
        
            <<< PhoneRow("OfIdent"){
                $0.hidden = Condition(booleanLiteral: !(UserDefaults.standard.getConfig()?.nroTramite != nil && UserDefaults.standard.getConfig()!.nroTramite))
                $0.title = "Of. Identidad"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.OfIdent
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            
            
            <<< TextRow("country"){
                $0.title = "Nacionalidad"
                $0.placeholder = "Obligatorio"
                $0.value = UserDefaults.standard.getUsuario()?.country
                $0.add(rule: RuleRequired())
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("provincia"){
                $0.title = "Provincia"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.province
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
                
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("department"){
                $0.title = "Partido"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.department
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
            <<< TextRow("city"){
                $0.title = "Localidad"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.city
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("district"){
                $0.title = "Barrio"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.district
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            
            <<< TextRow("street0"){
                $0.title = "Direccion"
                $0.placeholder = "Obligatorio"
                $0.value = UserDefaults.standard.getUsuario()?.street0
                $0.add(rule: RuleRequired())
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.validationOptions = .validatesOnChange
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
            <<< PhoneRow("streetNumber"){
                //$0.disabled = true
                $0.title = "Altura"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.streetNumber
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cell.titleLabel?.textColor = .red
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
            <<< TextRow("street1"){
                $0.title = "Entrecalle 1"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.street1
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("street2"){
                $0.title = "Entrecalle 2"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.street2
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
            <<< PhoneRow("floor"){
                $0.title = "Piso"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.floor
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
        
            <<< TextRow("door"){
                $0.title = "Departamento"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.door
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
        
        
            <<< TextRow("body"){
                $0.title = "Cuerpo"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.body
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("block"){
                $0.title = "Manzana"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.block
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            <<< TextRow("plat"){
                $0.title = "Parcela"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.plat
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            <<< TextRow("houseNumber"){
                $0.title = "Casa"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.houseNumber
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.hidden = Condition(booleanLiteral: formularioAcotado)
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }

    
           
            <<< PhoneRow("phoneNumber") {
                //$0.disabled = true
                $0.title = "Numero de Celular"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.phoneNumber
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                $0.cell.titleLabel?.textColor = .red
                
            
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
            
            <<< EmailRow("email"){
                $0.title = "Email"
                $0.placeholder = "Obligatorio"
                $0.disabled = UserDefaults.standard.getUsuario()?.imei != nil ? true : false
                $0.value = UserDefaults.standard.getUsuario()?.email
                $0.add(rule: RuleRequired())
                $0.add(rule: RuleEmail())
                $0.validationOptions = .validatesOnChange
                
            }
            .cellUpdate{cell, row in
                if !row.isValid {
                    cell.titleLabel? .textColor = .red
                }
            }
        
       
        if(UserDefaults.standard.getConfig()?.formularioJudicial != nil && UserDefaults.standard.getConfig()!.formularioJudicial) {
            form +++ Section("Datos judiciales")
                <<< TextRow("juzgado"){
                    $0.title = "Juzgado"
                    $0.placeholder = "Obligatorio"
                    $0.disabled = UserDefaults.standard.getUsuario()?.equiLabel != nil ? true : false
                    $0.value = UserDefaults.standard.getUsuario()?.juzgado
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate{cell, row in
                    if !row.isValid {
                        cell.titleLabel? .textColor = .red
                    }
                }
                <<< TextRow("causante"){
                    $0.title = "Causante"
                    $0.placeholder = "Obligatorio"
                    $0.disabled = UserDefaults.standard.getUsuario()?.equiLabel != nil ? true : false
                    $0.value = UserDefaults.standard.getUsuario()?.causante
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate{cell, row in
                    if !row.isValid {
                        cell.titleLabel? .textColor = .red
                    }
                }
                <<< TextRow("cautelar"){
                    $0.title = "Cautelar"
                    $0.placeholder = "Obligatorio"
                    $0.disabled = UserDefaults.standard.getUsuario()?.equiLabel != nil ? true : false
                    $0.value = UserDefaults.standard.getUsuario()?.cautelar
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate{cell, row in
                    if !row.isValid {
                        cell.titleLabel? .textColor = .red
                    }
                }
        }
       
        
        
        if (UserDefaults.standard.getUsuario()?.imei != nil || UserDefaults.standard.getUsuario()?.equiLabel != nil) {
            form +++ Section("Datos del dispositvo")
                <<< LabelRow(){
                    $0.hidden = UserDefaults.standard.getUsuario()?.imei == nil ? true : false
                    $0.title = "CodigoGPS"
                    $0.value = UserDefaults.standard.getUsuario()?.imei
                    $0.cell.detailTextLabel?.numberOfLines = 0
                    $0.cell.textLabel?.numberOfLines = 0
                }
                
                <<< LabelRow(){
                    $0.hidden = UserDefaults.standard.getUsuario()?.equiLabel == nil ? true : false
                    $0.title = "Etiqueta"
                    $0.value = UserDefaults.standard.getUsuario()?.equiLabel
                    $0.cell.detailTextLabel?.numberOfLines = 0
                    $0.cell.textLabel?.numberOfLines = 0
            }
        }
        
        if(UserDefaults.standard.getConfig()?.subclientes?.isEmpty == false) {
            form +++ Section("Tipo")
                <<< ActionSheetRow<String>("subcliente"){
                    $0.title = "Tipo de boton"
                    $0.selectorTitle = "Seleccione"
                    $0.options = UserDefaults.standard.getConfig()!.subclientes!
                        .compactMap({$0.id})
                    
                    $0.value =  UserDefaults.standard.getSubliente() != "" ? UserDefaults.standard.getSubliente() : UserDefaults.standard.getConfig()!.subclientes?.first?.id
                    $0.disabled = UserDefaults.standard.getUsuario()?.sex != nil ? true : false
                    $0.add(rule: RuleRequired())
                    $0.validationOptions = .validatesOnChange
                }
                .cellUpdate{cell, row in
                    if !row.isValid {
                        cell.textLabel? .textColor = .red
                    }
                }
        }
        
        
        
        form +++ Section("")
            <<< ButtonRow {
                $0.title = "Acerca de ..."
            }.onCellSelection {  cell, row in  self.openAbout() }
            <<< ButtonRow {
                $0.title = "Aviso a contactos"
                $0.hidden = Condition(booleanLiteral: (UserDefaults.standard.getConfig()?.avisoAContactos == false))
            }.onCellSelection {  cell, row in  self.openContact() }
        
        
        
    }
    
    private func openAbout() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let settingsViewController = storyBoard.instantiateViewController(withIdentifier: "about") as! AboutViewController
             self.present(settingsViewController, animated: true, completion: nil)
    }
    
    private func openContact() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
             let contactViewController = storyBoard.instantiateViewController(withIdentifier: "contact") as! ContactosViewController
             self.present(contactViewController, animated: true, completion: nil)
    }
    
    @IBAction func saveClick(_ sender: UIBarButtonItem) {
        if !form.validate().isEmpty {
            self.view.makeToast("Por favor complete todos los campos obligatorios.")
            return
        }
        
        
        let validateAlert = UIAlertController(title: "Ingrese código de validación", message: "Estos datos deben ser confirmados por personal autorizado del Municipio de San Isidro", preferredStyle: UIAlertController.Style.alert)
        
        validateAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Ingrese el codigo de validación"
            textField.isSecureTextEntry = true
        }
        
        validateAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            let codigoTextField = validateAlert.textFields![0] as UITextField
            
            
            if ("" == Constants.REGISTRATION_PASSWORD) {
                self.obtenerDatosFormulario(codgio:"\(codigoTextField.text!)")
            } else if (codigoTextField.text == Constants.REGISTRATION_PASSWORD) {
                self.obtenerDatosFormulario()
            } else {
                self.view.makeToast("Codigo Incorrecto", position: ToastPosition.top)
            }
            
            
        }))
        
        validateAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
            print("no pasa nada")
        }))
        
        present(validateAlert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    private func obtenerDatosFormulario(codgio: String = "") {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: form.values(), options: .prettyPrinted)
            let decoded = try JSONSerialization.jsonObject(with: jsonData, options: [])
            if let dictFromJSON = decoded as? [String:String] {
                var usuario = Usuario(dictionary: dictFromJSON)
                usuario.codigo = codgio
                
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways),
                    let currentLocation = locManager.location {
                    print(currentLocation.coordinate.latitude)
                    print(currentLocation.coordinate.longitude)
                    
                    usuario.lat = currentLocation.coordinate.latitude
                    usuario.lon = currentLocation.coordinate.longitude
                } else {
                    usuario.lat = 0.0
                    usuario.lon = 0.0
                }

                self.save(usuario: usuario)
            }
        } catch {
            print(error.localizedDescription)
        }
                         
        
    }
    
    
    
    //MARK: SAVE
    func save(usuario: Usuario){
        
        self.view.makeToastActivity(.center)
        

        if let subcliente = usuario.subcliente {
            UserDefaults.standard.setSubliente(subcliente: subcliente)
        }
        
        
        let request = ApiHelper.postRequest(php: "usuario.php")
        
        
        let json = SaveUserInfo( method: "saveUserInfo", data: usuario)
        
        guard let uploadData = try? JSONEncoder().encode(json) else {
            return
        }
        
        print(String(data: uploadData, encoding: .utf8)!)
        
        // self.pedirConfirmacion()
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
            
            
            if let error = error {
                print ("error: \(error)")
                DispatchQueue.main.async {
                    self.view.makeToast("error: \(error)", position: ToastPosition.top)
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    
                    let responseJSON = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let responseJSON = responseJSON as? [String: Any],
                        let output = responseJSON["output"] as? [String: Any],
                        let mensaje = output["resultData"] as? String
                    {
                        print(mensaje)
                        DispatchQueue.main.async {
                            self.view.makeToast(mensaje, position: ToastPosition.top)
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.view.makeToast("Error en el servidor", position: ToastPosition.top)
                        }
                    }
                    
                    
                    return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
                DispatchQueue.main.async {
                    self.view.makeToast("Los datos se guardaron correctamente", position: ToastPosition.top)
                    
                    UserDefaults.standard.setUsuario(usuario: usuario)
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "mapa") as! ViewController
                    viewController.modalPresentationStyle = .fullScreen
                    let navigationController = UINavigationController(rootViewController:  viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true, completion: nil)
                    
                }
            }
        }
        task.resume()
        
        
    }
    
    
    
    @IBAction func backClick(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
