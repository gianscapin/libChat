//
//  SelectChatViewController.swift
//  mobile 911
//
//  Created by Fernando Cerini on 12/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit

class SelectChatViewController: UITableViewController {
    
    private var botones: [Buttons] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.botones =  UserDefaults.standard.getConfig()?.types ?? []
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return botones.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellsButtons", for: indexPath) as! TypeTableViewCell

        let button = botones[indexPath.row]

        cell.textLabel?.text = button.name.uppercased()
        cell.textLabel?.backgroundColor = self.hexStringToUIColor(hex: button.backgroundColor ?? "#ffffff")
        cell.textLabel?.textColor =  self.hexStringToUIColor(hex: button.textColor ?? "#000000")
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat((button.fontSize ?? "30").floatValue))
        
        
        if let urlString = button.icon,
           let url = URL(string: urlString),
           let data = try? Data(contentsOf: url)
        {
            cell.imageView?.backgroundColor = self.hexStringToUIColor(hex: button.backgroundColor ?? "#ffffff")
            cell.imageView?.image = UIImage(data: data)
            
        }
        
        
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let boton = self.botones[indexPath.row]
        
        
        if let child = boton.childs, !child.isEmpty {
            self.botones = child
            self.tableView.reloadData()
        } else {
            if let urlString = boton.urlRedirect,
               let url = URL(string: generateUrl(url: urlString)) {
                UIApplication.shared.open(url)
            } else {                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let chatViewController = storyBoard.instantiateViewController(withIdentifier: "chatViewController") as! ChatViewController
                chatViewController.setVariables(tipo: String(boton.id), firstMsg: boton.name)
                chatViewController.modalPresentationStyle = .fullScreen
                self.present(chatViewController, animated: true, completion: nil)
            }
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func generateUrl(url: String) -> String {

 
        let usuario = UserDefaults.standard.getUsuario()
        let newUrl = url.replacingOccurrences(of: "{{nombre}}", with: usuario?.firstName ?? "" + "_" + (usuario?.lastName ?? ""))
        return newUrl.replacingOccurrences(of: "{{telefono}}", with: usuario?.phoneNumber ?? "")
        
        
        
        
    }
}


