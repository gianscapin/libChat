//
//  Contactos.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 23/02/2023.
//  Copyright © 2023 Soflex. All rights reserved.
//

import Foundation

struct Contacto: Codable {
    
    var uno, dos, tres, cuatro, cinco: String?
    
    
    init(dictionary: [String: Any]) {
        self.uno = dictionary["uno"] as? String
        self.dos = dictionary["dos"] as? String
        self.tres = dictionary["tres"] as? String
        self.cuatro = dictionary["cuatro"] as? String
        self.cinco = dictionary["cinco"] as? String
    }
    
    
    func toArray(number: String?) -> Array<String> {
        return [
            self.uno,
            self.dos,
            self.tres,
            self.cuatro,
            self.cinco,
            number
        ].compactMap { $0 }
    }
}
