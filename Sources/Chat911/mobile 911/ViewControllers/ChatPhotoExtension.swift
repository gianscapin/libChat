//
//  ChatPhotoExtension.swift
//  mobile 911
//
//  Created by Fernando Cerini on 16/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//
import UIKit
import SnapKit

import MobileCoreServices

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    enum ImageSource {
        case photoLibrary
        case camera
        case video
    }
    
    func clipShowMenu() {
        let alert = UIAlertController(title: "Enviar a 911", message: "Seleccione una de las opciones.", preferredStyle: .actionSheet)
        
        let okPhoto = UIAlertAction(title: "Foto desde la Camara", style: .default, handler: {(alert: UIAlertAction!) in self.takePhoto()})
        let img = UIImage(named: "camera.png")
        okPhoto.setValue(img, forKey: "image")
        alert.addAction(okPhoto)
        
        let okVideo = UIAlertAction(title: "Video desde la Camara", style: .default, handler: {(alert: UIAlertAction!) in self.takeVideo()})
        let img2 = UIImage(named: "video.png")
        okVideo.setValue(img2, forKey: "image")
        alert.addAction(okVideo)
        
//        let okGal = UIAlertAction(title: "Foto desde la galeria", style: .default, handler: {(alert: UIAlertAction!) in self.selectImageFrom(.photoLibrary)})
//        let img3 = UIImage(named: "gallery.png")
//        okGal.setValue(img3, forKey: "image")
//        alert.addAction(okGal)
//
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

    func takeVideo() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.video)
    }

    func takePhoto() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        selectImageFrom(.camera)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .video:
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            imagePicker.videoMaximumDuration = 10
            imagePicker.videoQuality = .typeLow
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        
        guard info[UIImagePickerController.InfoKey.mediaType] != nil else { return }
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        
        switch mediaType {

        case kUTTypeImage:
            guard let img = info[.originalImage] as? UIImage else {
                print("Image not found!")
                return
            }
            
            self.sendImage(img: img)

            break

        case kUTTypeMovie:
            if let fileURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL,
                let bytes = NSData(contentsOf: fileURL as URL)
                {
                    self.sendVideo (video: bytes)
                }
            
            break

        default:
            break
        }
        
    }
    
    func addImage( img: UIImage, time: String ){
        
        let imgMessage = UIImageView()
        imgMessage.image = img
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

        
    }
    
}

