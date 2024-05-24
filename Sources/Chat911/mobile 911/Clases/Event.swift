//
//  Event.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

struct Event: Codable {
    let id: String
    let date: String
    let lat: Double
    let lon: Double
    let speed: Double
    let bearing: Double
    let acc: Double
    let bat: Float
    let type: Int
    let evento: Int
    var online: Int
    
    

    init(evento: Evento) {
        self.id = evento.id!
        self.date = evento.date!
        self.lat = evento.lat
        self.lon = evento.lon
        self.speed = evento.speed
        self.bearing = evento.bearing
        self.acc = evento.acc
        self.bat = evento.bat
        self.type = Int(evento.type)
        self.evento = Int(evento.evento)
        self.online = Int(evento.online)
    }
}
