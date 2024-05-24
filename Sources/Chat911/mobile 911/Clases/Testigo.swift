//
//  Testigo.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import UIKit

enum EstadoGPS {
    case OK
    case ERROR
    case DISABLE
}

enum EstadoRED {
    case OK
    case ERROR
    case DISABLE
}

class Testigo {
    let id: Int
    let texto: String
    let icon: UIImage
    let color: UIColor
    
    init(id: Int, texto: String, icon: UIImage, color: UIColor) {
        self.id = id
        self.texto = texto
        self.icon = icon
        self.color = color
    }
}
