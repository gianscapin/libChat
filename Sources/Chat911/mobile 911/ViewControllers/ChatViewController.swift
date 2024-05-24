//
//  ChatViewController.swift
//  mobile 911
//
//  Created by Fernando Cerini on 12/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation


class ChatViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var vMensajes: UIView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var vEnviar: UIView!
    
    @IBOutlet weak var texto: UITextView!
    
    @IBOutlet weak var clip: UIButton!
    @IBOutlet weak var send: UIButton!
    
    var imagePicker: UIImagePickerController!

    
    var timer: Timer?
    
    var idMessage = 0
    var idSession = ""
    var idHumanSession = ""
    var idUser = ""
    var lastIdMessage = "0"
    
    var semeId = 0 //ultimo mensaje desde 911
    
    var tipo = "..." //se setean en selectchat
    var force = "1"
    var firstMsg = ""
    
    
    var audioRecorder: AVAudioRecorder?
    var audioFileURL: URL?
    
    
    var player: AVAudioPlayer?
    
    var mapData: [Int: Data] = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.setBackgroundImage(UIImage(named: "ba-banner"), for: .default)
        navBar.topItem?.title = "CHAT"
        
        initView()
        self.initChat(firstMsg: self.firstMsg , tag: Int(tipo)!)

        texto.delegate = self
        
        
        self.setupAudioRecorder()
        
    }
    
    

    

    
    func textViewDidChange(_ textView: UITextView) {
        changeIcon()
    }
    
    private func changeIcon() {
        var nuevoIcono = UIImage(named: "send-button")
        if(texto.text.count == 0) {
            nuevoIcono = UIImage(named: "mic")
        }
        
        send.setImage(nuevoIcono, for: .normal)
    }
    
    
    
    func setVariables(tipo: String, firstMsg: String) {
        self.tipo = tipo
        self.firstMsg = firstMsg
    }
    
    // MARK: CLICKS
    
    @IBAction func sendClick(_ sender: Any) {
        
        if (texto.text.count < 1) {
            if (audioRecorder?.isRecording != false) {
                audioRecorder?.stop()
   
            } else {
                audioRecorder?.record()
            }   
            return
        }
        
        if (self.idMessage == 0){
            self.initChat( firstMsg: self.texto.text , tag: 1)
        } else {
            self.sendText(msg: self.texto.text)
        }
        
    }
    
    @IBAction func clipClick(_ sender: Any) {
        self.clipShowMenu()
    }
    

    
    @IBAction func cancelClick(_ sender: Any) {
        
        let cancelAlert = UIAlertController(title: "Abandonar Chat", message: "Esta seguro que quiere cerrar el chat?.", preferredStyle: UIAlertController.Style.alert)
        
        cancelAlert.addAction(UIAlertAction(title: "Abandonar", style: .default, handler: { (action: UIAlertAction!) in
            
            self.closeSession()
            
            self.timer?.invalidate()
            self.performSegue(withIdentifier: "cerrar", sender: nil)
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: { (action: UIAlertAction!) in
            print("no pasa nada")
        }))
        
        present(cancelAlert, animated: true, completion: nil)
    }
    
    
    //MARK: FUNC
    
    func now()-> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        return formatter.string(from: date)

    }
    
    
    
    func showMessage(msg: String, data: Data?, time: String, user: Bool, tag: Int, tipo: Tipo, estado: Estado = .Enviando) {
        
        let view = stack.viewWithTag(tag)
        // && user == false
        if view != nil {
            
            let indicador = view?.viewWithTag(99) as! UIImageView
            indicador.image = getImageByEstado(estado: estado)
            return
        }

        // Burbuja de contenido
        let box = UIView()
        box.tag = tag
        
        
        // Indicador
        let indicador = UIImageView(image:getImageByEstado(estado: estado))
        indicador.tag = 99
        indicador.frame = box.bounds
        indicador.contentMode = .scaleAspectFill
//        indicador.backgroundColor = getColorByEstado(estado: estado)
//        indicador.layer.cornerRadius = 8
        indicador.isHidden = !user
        box.addSubview(indicador)
        
        
        switch tipo {
        case .Sistema, .Texto, .Inicio, .Fin:
            let label = PaddingLabel()
            label.text = msg
            label.backgroundColor = UIColor.white
            
            if user {
                label.backgroundColor = UIColor(red: 0xe1, green: 0xf7, blue: 0xca)
            }
            
            box.addSubview(label)
            
            
            // Agrego fecha
            let lbTime = UILabel()
            lbTime.text = time
            box.addSubview(lbTime)
            
            let width = UIScreen.main.bounds.size.width
            
            box.snp.makeConstraints { (make) -> Void in
                make.width.equalTo( width * 0.99 )
                make.height.greaterThanOrEqualTo(60)
            }
            
            var edges = UIEdgeInsets(top: 2, left: 2, bottom: 20, right: 100)
            if (user){
                edges = UIEdgeInsets(top: 2, left: 100, bottom: 20, right: 2)
            }
            
            label.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(box).inset( edges )
            }
            
            indicador.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.top.equalTo(label.snp.bottom).offset(8)
                make.right.equalTo(label.snp.right)
                
            }
            // Posiciono fecha
            lbTime.snp.makeConstraints { (make) -> Void in
                 make.right.equalTo(indicador.snp.left).offset(-8)
                 make.centerY.equalTo(indicador.snp.centerY)
            }
            
            
            
            break
        case .Imagen, .Video:
             
            let imgMessage = UIImageView()
            imgMessage.image = UIImage(data: data!)
            imgMessage.contentMode = .scaleAspectFit
            
            let lbTime = UILabel()
            lbTime.text = time

            let box = UIView()
            box.addSubview(imgMessage)
            box.addSubview(lbTime)
            
            let width = UIScreen.main.bounds.size.width
            
            box.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(width)
                make.height.equalTo(220)
            }
            
            let edges =  UIEdgeInsets(top: 2, left: 100, bottom: 20, right: 2)
            
            imgMessage.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(box).inset( edges )
            }
            
            lbTime.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(imgMessage.snp.bottom)
                make.right.equalTo(imgMessage.snp.right)
            }

            stack.addArrangedSubview( box )
            
            scroll.scrollToBottom(animated: true)
            scroll.scrollToBottom(animated: true)
            
            
            break
        case .Audio:
            
            let label = PaddingLabel()
            label.text = "Audio"
            label.backgroundColor = UIColor.white
            
            if user {
                label.backgroundColor = UIColor(red: 0xe1, green: 0xf7, blue: 0xca)
            }
            
            box.addSubview(label)
            
            mapData[tag] = data
            
            
            let playButton = UIButton()
            playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
            playButton.setTitleColor(UIColor.blue, for: .normal)
            playButton.tag = tag
            playButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)


            box.addSubview(playButton)

            playButton.snp.makeConstraints { (make) in
                make.centerY.equalTo(label.snp.centerY)
                make.left.equalTo(label.snp.right).offset(8)
            }
            
            
            // Agrego fecha
            let lbTime = UILabel()
            lbTime.text = time
            box.addSubview(lbTime)
            
            let width = UIScreen.main.bounds.size.width
            
            box.snp.makeConstraints { (make) -> Void in
                make.width.equalTo( width * 0.99 )
                make.height.greaterThanOrEqualTo(60)
            }
            
            var edges = UIEdgeInsets(top: 2, left: 2, bottom: 20, right: 100)
            if (user){
                edges = UIEdgeInsets(top: 2, left: 100, bottom: 20, right: 2)
            }
            
            label.snp.makeConstraints { (make) -> Void in
                make.top.left.bottom.equalToSuperview().inset(edges)
                make.right.equalToSuperview().inset(edges.right + 40)
            }
            
            indicador.snp.makeConstraints { make in
                make.width.height.equalTo(16)
                make.top.equalTo(playButton.snp.bottom).offset(8)
                make.right.equalTo(playButton.snp.right)
                
            }
            // Posiciono fecha
            lbTime.snp.makeConstraints { (make) -> Void in
                 make.right.equalTo(indicador.snp.left).offset(-8)
                 make.centerY.equalTo(indicador.snp.centerY)
            }
            
            
            
            break

        }
        
      



        // Agrego a la lista, voy para abajo y borro el texto
        stack.addArrangedSubview( box )
        scroll.scrollToBottom(animated: true)
        texto.text = ""
        changeIcon()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        if let data = mapData[sender.tag] {
            do {
                player = try AVAudioPlayer(data: data)
                player?.prepareToPlay()
                player?.play()
            } catch {
                print("Error al crear el objeto AVAudioPlayer: \(error.localizedDescription)")
            }
        }
        
    
    }
    
    
    
    //MARK: INIT
    func initView() {
        
        
        vMensajes.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 2, left: 2, bottom: 48, right: 2))
            make.height.equalTo(48)
        }
        navBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(44)

        }
        
        scroll.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(navBar.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        stack.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        

        
        vEnviar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(scroll.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        texto.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 4, left: 40, bottom: 4, right: 40))
        }
        texto.layer.cornerRadius = 12.0
        texto.layer.borderWidth = 1.0
        texto.layer.borderColor = UIColor.lightGray.cgColor
        


        send.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(4)
        }

        clip.snp.makeConstraints { (make) -> Void in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(4)
        }
        

        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
    
    func initTimer(){
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            
            self.checkMessages()
        }
    }
    
    
    
    @objc func initialBtnClick(sender: UIButton!) {
        
    }
    
    
    
    private func getColorByEstado(estado: Estado) -> UIColor {
        switch estado {
            
        case .Enviando:
            return .gray
        case .Enviado:
            return UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 1.0)
        case .Recibido:
            return .gray
        case .Leido:
            return UIColor(red: 0.5, green: 0.7, blue: 0.9, alpha: 1.0)
        case .Error:
            return .red
        }
    }
    
    
    private func getImageByEstado(estado: Estado) -> UIImage {
        switch estado {
            
        case .Enviando:
            return UIImage(named: "enviando")!
        case .Enviado:
            return UIImage(named: "enviado")!
        case .Recibido:
            return UIImage(named: "enviado")!
        case .Leido:
            return UIImage(named: "enviado")!
        case .Error:
            return UIImage(named: "enviado")!
        }
    }
    
    
}
