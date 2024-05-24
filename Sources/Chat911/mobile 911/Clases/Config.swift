//
//  Config.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

struct Config: Codable {
    var phoneNumber: String
    var urlPanic: String?
    let area: String
    let types: [Buttons]?
    let subclientes: [Subcliente]?
    let termsAndConditionsDate: Date?
    let buttons: [String] = ["btnSOS"]
    let map: Bool = false
    let videoType: Int = 59
    let reportConfig: ReportConfig
    let messageConfig: MessageConfig
    let logs: Bool = true
    let enviarCodigo: Bool = false
    let nroTramite: Bool = false
    let version: String?
    let logApagadoEncendido:Bool = true
    let logGPSApagadoEncendido:Bool = true
    let enviarPosicionesSinGPS: Bool = true
    let sosRetardTime:Int = 3500
    let formularioJudicial : Bool = false
    let formularioAcotado: Bool = true
    let avisoAContactos: Bool = true
}


struct ReportConfig: Codable  {
    let positionReport: Int?
    let panicReport: Int = 60
    let panicReportTime: Int = 3600
}

struct MessageConfig: Codable  {
    let smsNumber: String?
    let smsTemplatePanic: String?
}

struct Buttons: Codable{
    let id: Int
    let name: String
    let icon: String?
    let backgroundColor: String?
    let textColor: String?
    let fontSize: String?
    let childs: [Buttons]?
    let urlRedirect:String?
    let labelPlace: String?
    
}

struct Subcliente: Codable {
    let id: String
    let nombre: String
}
