//
//  VideoChatViewController.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 27/09/2019.
//  Copyright © 2019 Soflex. All rights reserved.
//

import UIKit

class VideoChatViewController: UIViewController {
    
    var tipo = "..." //se setean en selectchat
    var force = "1"
    var timer: Timer?
    var idSession = ""
    var idUser = ""
    var semeId = 1
    var idMessage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initChat(firstMsg: "VIDEOCHAT", tag: 58)
    
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
    
        loadingIndicator.startAnimating();
        
        let cancelAlert = UIAlertController(title: nil, message: "Conectando, por favor espere ...", preferredStyle: UIAlertController.Style.alert)
        
        
        cancelAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
            self.closeSession()
            self.timer?.invalidate()
            self.timer = nil
            self.navigationController?.popViewController(animated: true)
        }))
        
        
        cancelAlert.view.addSubview(loadingIndicator)
        present(cancelAlert, animated: true, completion: nil)
    }
    
    
    func initChat( firstMsg: String, tag: Int ){
    
        self.view.makeToastActivity(.center)
    
        let request = ApiHelper.postRequest(php: "chat.php")
        
        let aux = RequestChatData(
            code: UserDataHelper.getId(),
            userType: "1",
            nick: ((UserDefaults.standard.getUsuario()?.lastName!)!) +  ", " + ((UserDefaults.standard.getUsuario()?.firstName!)!),
            force:  self.force,
            typification:  "",
            initialMessage:  "",
            campoInt1: String(tag)
        )
        
        let json = RequestChat( method: "requestChat", data: aux)
        
        guard let uploadData = try? JSONEncoder().encode(json) else {
            return
        }
        
        print(String(data: uploadData, encoding: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
            
            
            if let error = error {
                print ("error: \(error)")
    
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8),
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]) as [String : String]??),
                let result = json?["result"],
                let idSession = json?["idSession"],
                let idUser = json?["idUser"]
            {
                
                print ("data: \(dataString)")
                print (result)
                if (result == "OK"){
                    self.idUser = idUser
                    self.idSession = idSession
                    DispatchQueue.main.async {
                        self.sendMessage(msg: firstMsg)
                        self.initTimer()
                    }
                }
            }
        }
        task.resume()
        
        
    }
    
    func initTimer(){
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            self.checkMessages()
        }
    }
    
    
    func checkMessages() {
        
        print ("timer")
        
        let request = ApiHelper.postRequest(php: "chat.php")
        
        let aux = SyncSessionStatusData(
            idSession: self.idSession,
            source: "IOS",
            idUser: self.idUser,
            lat: ViewController.lastLat,
            lng: ViewController.lastLon,
            alt: "1",
            lastIdMessage: self.semeId,
            messages: [ ]
        )
        
        let json = SyncSessionStatus( method: "syncSessionStatus", data: aux)
        
        guard let uploadData = try? JSONEncoder().encode(json) else {
            return
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            
            if error != nil {
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            
            if  let data = data,
                let dataString = String(data: data, encoding: .isoLatin1),
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??),
                let result = json?["result"] as? String,
                result == "OK",
                let messages = json?["messages"] as? [Any],
                messages.count > 0,
                let msg1 = messages[0] as? [String: Any],
                let semeId = msg1["seme_id"] as? Int,
                let msg = msg1["seme_mensaje"] as? String
            {
                
                print ("data: \(dataString)")
                print (semeId)
                
                self.semeId = semeId
                
                DispatchQueue.main.async {
                    let codeB64 = msg.base64Decoded()
                    if(!self.verifyUrl(urlString: codeB64)) {
//                    UIApplication.shared.open(URL(string: codeB64!)!)
                    }
                }
            }
        }
        
        task.resume()
        
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                 UIApplication.shared.open(url)
                return true
            }
        }
        return false
    }
    
    
    func sendMessage ( msg: String ){
        
        self.view.makeToastActivity(.center)
        
        
        let request = ApiHelper.postRequest(php: "chat.php")
        
        
        
        let auxMsg = Message(
            idMessage: String(self.idMessage),
            sender: (UserDefaults.standard.getUsuario()?.phoneNumber)!,
            type: "2",
            message: msg.base64Encoded()! )
        
        let aux = SyncSessionStatusData(
            idSession: self.idSession,
            source: "IOS",
            idUser: self.idUser,
            lat: ViewController.lastLat,
            lng: ViewController.lastLon,
            alt: "1",
            lastIdMessage: self.semeId,
            messages: [ auxMsg ]
        )
        
        let json = SyncSessionStatus( method: "syncSessionStatus", data: aux)
        
        guard let uploadData = try? JSONEncoder().encode(json) else {
            return
        }
        
        print(String(data: uploadData, encoding: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            
            DispatchQueue.main.async {
                self.view.hideToastActivity()
            }
            
            
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8),
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??),
                let result = json?["result"] as? String
            {
                
                print ("data: \(dataString)")
                print (result)
                if (result == "OK"){
                    DispatchQueue.main.async {
                        self.idMessage += 1
                    }
                }
            }
        }
        task.resume()
    }
    
    func closeSession() {
        if (self.idSession != "" || self.idUser != "") {
            let request = ApiHelper.postRequest(php: "chat.php")
            
            let aux = CloseSessionData(
                idSession: self.idSession,
                idUser: self.idUser
            )
            
            let json = CloseSession( method: "closeSession", data: aux)
            
            guard let uploadData = try? JSONEncoder().encode(json) else {
                return
            }
            
            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
                if error != nil {
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        return
                }
                
            }
            
            task.resume()
        }
        
    }

}
