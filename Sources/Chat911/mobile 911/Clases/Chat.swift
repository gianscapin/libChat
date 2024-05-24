//
//  Example.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

struct RequestChat: Codable {
    let method: String
    let data: RequestChatData
}
struct RequestChatData: Codable {
    let code: String
    let userType: String
    let nick: String
    let force: String
    let typification: String
    let initialMessage: String
    let campoInt1: String
}

struct SyncSessionStatus: Codable {
    let method: String
    let data: SyncSessionStatusData
}
struct SyncSessionStatusData: Codable {
    let idSession: String
    let source: String
    let idUser: String
    let lat: String
    let lng: String
    let alt: String
    let lastIdMessage: Int
    let messages: [Message]
}
struct Message: Codable {
    let idMessage: String
    let sender: String
    let type: String
    let message: String
}

struct CloseSession: Codable {
    let method: String
    let data: CloseSessionData
}
struct CloseSessionData: Codable {
    let idSession: String
    let idUser: String
}

enum Tipo: Int {
    case Sistema = 1
    case Texto = 2
    case Imagen = 3
    case Video = 4
    case Audio = 5
    case Inicio = 6
    case Fin = 7
}

enum Estado {
    case Enviando
    case Enviado
    case Recibido
    case Leido
    case Error
}
