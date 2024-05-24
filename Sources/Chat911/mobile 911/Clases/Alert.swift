//
//  Alert.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

struct Alert: Codable {
    let id: String
    let position: Position
    let asset: Asset
    let battery: String
    let ts: String
    let emergencycall: String
    let startemergency: String
    let dialnumber: String
}

struct Position: Codable {
    let lat: String
    let lon: String
    let speed: String
    let altitude: String
    let course: String
    let acc: String
}

struct Asset: Codable {
    let id: String
    let phone: String
}
