//
//  Response.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

struct Response: Codable {
    let result: String
}

struct ResponseMultimedia: Codable {
    let url: String
}
