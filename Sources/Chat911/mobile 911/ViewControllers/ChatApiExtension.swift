//
//  ChatApiExtension.swift
//  mobile 911
//
//  Created by Fernando Cerini on 04/12/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit
import Toast_Swift
import RxSwift
import Alamofire
import RxAlamofire



extension ChatViewController {
    
    func initChat(firstMsg: String, tag: Int){
        self.view.makeToastActivity(.center)
        
        let request = ApiHelper.postRequest(php: "chat.php")
        
        let aux = RequestChatData(
            code: UserDataHelper.getId(),
            userType: "1",
            nick: (UserDefaults.standard.getUsuario()?.lastName)! + ", " + (UserDefaults.standard.getUsuario()?.firstName)!,
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
                DispatchQueue.main.async {
                    self.view.makeToast("error: \(error)", position: ToastPosition.top)
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    DispatchQueue.main.async {
                        self.view.makeToast("Error de conexion", position: ToastPosition.top)
                    }
                    return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8),
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String]) as [String : String]??),
                let result = json?["result"],
                let idSession = json?["idSession"],
                let idUser = json?["idUser"],
                let idSessionHuman = json?["idSessionHuman"]
                {
                
                    print ("data: \(dataString)")
                    print (result)
                    if (result == "OK"){
                        DispatchQueue.main.async {
                            self.idMessage = 1
                            self.idUser = idUser
                            self.idSession = idSession
                            self.idHumanSession = idSessionHuman
                            self.navBar.topItem?.title = "CHAT #" + idSessionHuman
                            self.initTimer()
                            self.clip.isEnabled = true
                            self.sendText(msg: firstMsg)
                            
                        }
                    }
            }
        }
        task.resume()
        
        
    }
    
    
    func sendMessage( msg: String, idMensaje: Int ,tipo: Tipo = .Texto ){
        
        self.view.makeToastActivity(.center)
        
        let request = ApiHelper.postRequest(php: "chat.php")

        let auxMsg = Message(
                            idMessage: String(self.idMessage),
                            sender: (UserDefaults.standard.getUsuario()?.phoneNumber)!,
                            type: String(tipo.rawValue),
                            message: msg )
        
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
                DispatchQueue.main.async {
                    self.view.makeToast("error: \(error)", position: ToastPosition.top)
                }
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    DispatchQueue.main.async {
                        self.view.makeToast("Error de conexion", position: ToastPosition.top)
                    }
                    return
            }
            if  let data = data,
                let dataString = String(data: data, encoding: .utf8),
                let json = ((try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]) as [String : Any]??),
                let result = json?["result"] as? String
            {
                
                if (result == "OK"){
                    DispatchQueue.main.async {
                        self.showMessage(msg: msg, data: nil, time: self.now(), user: true, tag: idMensaje,tipo: .Texto, estado: .Enviado)
                    }
                } else {
                    self.showMessage(msg: msg, data: nil, time: self.now(), user: true, tag: idMensaje,tipo: .Texto, estado: .Error)
                }
            } else {
                self.showMessage(msg: msg, data: nil, time: self.now(), user: true, tag: idMensaje,tipo: .Texto, estado: .Error)
            }
        }
        task.resume()
    }
    
    func sendText(msg: String) {
        self.idMessage += 1
        self.showMessage(msg: msg, data: nil, time: self.now(), user: true, tag: self.idMessage,tipo: .Texto)
        self.sendMessage(msg: msg, idMensaje: self.idMessage)
    }
    
    func sendImage(img: UIImage){
        self.idMessage += 1
        guard let imageData = img.jpegData(compressionQuality: 0.5) else { return }
        self.showMessage(msg: "", data: imageData, time: self.now(), user: true, tag: self.idMessage,tipo: .Imagen)
        uploadFile(data: imageData, idMessage: self.idMessage,tipo: .Imagen)
    }

    func sendVideo(video: NSData){
        self.idMessage += 1
        if let imgVideo =  UIImage(named: "video.png")?.pngData() {
            self.showMessage(msg: "", data: imgVideo, time: self.now(), user: true, tag: self.idMessage,tipo: .Video)
            uploadFile(data: Data(referencing: video), idMessage: self.idMessage, tipo: .Video)
        }
       
    }

    func sendAudio(audioUrl: URL){
        self.idMessage += 1
        do {
            let audioData = try Data(contentsOf: audioUrl)
            self.showMessage(msg: "", data: audioData, time: self.now(), user: true, tag: self.idMessage,tipo: .Audio)
            uploadFile(data: audioData, idMessage: self.idMessage, tipo: .Audio)
            
        } catch let error {
            print("Error al obtener los datos del archivo de audio: \(error.localizedDescription)")
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
        
        print(String(data: uploadData, encoding: .utf8)!)
        
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
                let msg = msg1["seme_mensaje"] as? String,
                let tipo = msg1["seme_meti_id"] as? Int
                {
                
                    print ("data-message: \(dataString)")
                    print (semeId)
                    
                    self.semeId = semeId

                    DispatchQueue.main.async {
                        let t = Tipo(rawValue: tipo)!
                        self.showMessage(msg: msg, data: nil ,time: self.now(), user: false, tag: semeId, tipo: t)
                    }
                }
        }
        
        task.resume()

    }

    func closeSession() {
        
        let request = ApiHelper.postRequest(php: "chat.php")
        
        let aux = CloseSessionData(
            idSession: self.idSession,
            idUser: self.idUser
        )
        
        let json = CloseSession(method: "closeSession", data: aux)
        
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
    
    
    func uploadFile(data: Data,idMessage: Int, tipo: Tipo) {
        let url = "https://gchu.soflex.com.ar:11443/saeChatBPSanJuan/chat-m/chat/multimedia.php"
        let name = String(arc4random_uniform(90000) + 10000) + self.getExt(tipo: tipo)
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(data, withName: "archivo", fileName: name, mimeType: self.getMimeType(tipo: tipo))
            multipartFormData.append(self.idHumanSession.data(using: .utf8)!, withName: "idSession")
        },to: url).responseJSON(completionHandler: { [self] response in
            switch response.result {

            case .success(let value):
                if let JSON = value as? [String: Any] {
                    let url = JSON["url"] as! String
                    self.sendMessage(msg: url, idMensaje: idMessage, tipo: tipo)
                }
            case .failure(_): break
            }
         })
        

    }
    
    
    private func getMimeType(tipo: Tipo) -> String {
        switch tipo {
            case .Video:
                 return "video/mp4"
            case .Audio:
                return "audio/mp4"
            case .Imagen:
                return "image/jpeg"
            default:
                return ""

        }
    }
    
    private func getExt(tipo: Tipo) -> String {
        switch tipo {
            case .Video:
                 return ".mp4"
            case .Audio:
                return ".m4a"
            case .Imagen:
                return ".jpeg"
            default:
                return ""

        }
    }

}
