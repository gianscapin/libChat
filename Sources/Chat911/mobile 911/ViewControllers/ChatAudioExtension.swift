//
//  ChatAudioExtension.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 10/05/2023.
//  Copyright © 2023 Soflex. All rights reserved.
//

import Foundation
import AVFoundation
//import lame


extension ChatViewController: AVAudioRecorderDelegate {
    
    
    
    func setupAudioRecorder() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: [])
            try audioSession.setActive(true)
            
            let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.prepareToRecord()
            
        } catch {
            print("Error setting up audio recorder: \(error.localizedDescription)")
        }
    }
    
    
    func getDocumentsDirectory() -> URL {
          let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
          let documentsDirectory = paths[0]
          return documentsDirectory
      }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
           if flag {
                    let audioURL = recorder.url
                    
                    do {
                        let audioData = try Data(contentsOf: audioURL)
                        self.sendAudio(audioUrl: audioURL)
                    } catch let error {
                        print("Error al obtener los datos del archivo de audio: \(error.localizedDescription)")
                    }
           } else {
               // Audio recording failed. Handle the error.
               print("Audio recording failed")
           }
       }
       
       func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
           if let e = error {
               print("Audio recording encoding error: \(e.localizedDescription)")
           }
       }
    
    
}
