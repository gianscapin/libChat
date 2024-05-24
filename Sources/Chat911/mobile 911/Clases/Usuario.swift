//
//  Usuario.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import UIKit

struct SaveUserInfo: Codable {
    let method: String
    let data: Usuario?
}

struct GetUserInfo: Codable {
    let method: String
    let id: String
}

struct RespuestaUsuario: Codable {
    let result: String?
    let output: Usuario?
}


struct RespuestaCredencial: Codable {
   let result: String
   let output: CodigoGPS?
}

struct CodigoGPS: Codable {
   let codigo_gps: String
}



struct GetCredenciales: Codable {
   let method: String
   let data: Credenciales
}




struct Credenciales: Codable {
   let user: String
   let pass: String
}



struct Usuario: Codable {
    
    var firstName, lastName, docNumber: String?
    var phoneNumber, imei, email, country: String?
    var street0, docType, sex, equiLabel: String?
    var codigo: String?
    var lat, lon: Double?
    
    var OfIdent,expediente: String?
    var juzgado, causante, cautelar, userExists, streetNumber: String?
    var street1, street2, province, department, city, district: String?
    var floor, body, block, plat, houseNumber, door: String?
    var modelo , marca, version, subcliente : String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "mous_nombre"
        case lastName = "mous_apellido"
        case docNumber = "mous_documento"
        case phoneNumber = "mous_telefono"
        case imei = "mous_imei"
        case street0 = "mous_calle"
        case country = "mous_pais"
        case email = "mous_email"
        case docType = "mous_tipodoc"
        case sex = "mous_sexo"
        case equiLabel = "equi_label"
        case codigo = "codigo"
        case lat = "lat"
        case lon = "lon"
        
        case OfIdent = "OfIdent"
        case modelo = "modelo"
        case marca = "marca"
        case version = "version"
        case expediente = "expediente"
        case juzgado = "juzgado"
        case causante = "causante"
        case cautelar = "cautelar"
        case userExists = "userExists"
        case streetNumber = "mous_altura"
        case street1 = "mous_calle_entre_1"
        case street2 = "mous_calle_entre_2"
        case province = "mous_provincia"
        case department = "mous_partido"
        case city = "mous_localidad"
        case district = "mous_barrio"
        case floor = "mous_piso"
        case body = "mous_cuerpo"
        case block = "mous_manzana"
        case plat = "mous_parcela"
        case houseNumber = "mous_casa"
        case door = "mous_depto"
        case subcliente = "mous_subcliente"

    }
    
    enum DecodingKeys: String, CodingKey {
        case streetNumber = "streetNumber"
        case firstName = "firstName"
        case lastName = "lastName"
        case docNumber = "docNumber"
        case phoneNumber = "phoneNumber"
        case imei = "imei"
        case street0 = "street0"
        case country = "country"
        case email = "email"
        case docType = "docType"
        case sex = "sex"
        case equiLabel = "equiLabel"
        case codigo = "codigo"
        case lat = "lat"
        case lon = "lon"
        case subcliente = "subcliente"
        case OfIdent = "OfIdent"
        case modelo = "modelo"
        case marca = "marca"
        case version = "version"
        case expediente = "expediente"
        case juzgado = "juzgado"
        case causante = "causante"
        case cautelar = "cautelar"
        case userExists = "userExists"
        case street1 = "street1"
        case street2 = "street2"
        case province = "province"
        case department = "department"
        case city = "city"
        case district = "district"
        case floor = "floor"
        case body = "body"
        case block = "block"
        case plat = "plat"
        case houseNumber = "houseNumber"
        case door = "door"
    }
    
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DecodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(docNumber, forKey: .docNumber)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(imei, forKey: .imei)
        try container.encode(street0, forKey: .street0)
        try container.encode(country, forKey: .country)
        try container.encode(docType, forKey: .docType)
        try container.encode(email, forKey: .email)
        try container.encode(sex, forKey: .sex)
        try container.encode(equiLabel, forKey: .equiLabel)
        try container.encode(codigo, forKey: .codigo)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        
        try container.encode(OfIdent, forKey: .OfIdent)
        try container.encode(modelo, forKey: .modelo)
        try container.encode(marca, forKey: .marca)
        try container.encode(version, forKey: .version)
        try container.encode(juzgado, forKey: .juzgado)
        try container.encode(causante, forKey: .causante)
        try container.encode(cautelar, forKey: .cautelar)
        try container.encode(userExists, forKey: .userExists)
        try container.encode(street1, forKey: .street1)
        try container.encode(street2, forKey: .street2)
        try container.encode(province, forKey: .province)
        try container.encode(department, forKey: .department)
        try container.encode(city, forKey: .city)
        try container.encode(district, forKey: .district)
        try container.encode(floor, forKey: .floor)
        try container.encode(body, forKey: .body)
        try container.encode(block, forKey: .block)
        try container.encode(plat, forKey: .plat)
        try container.encode(houseNumber, forKey: .houseNumber)
        try container.encode(door, forKey: .door)
        try container.encode(subcliente, forKey: .subcliente)
        

    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let country = try? container.decode(String.self, forKey: .country) {
            self.country = country
        }
        
        if let docNumber = try? container.decode(String.self, forKey: .docNumber) {
            self.docNumber = docNumber
        }
        
        if let docType = try? container.decode(String.self, forKey: .docType) {
            self.docType = docType
        }
        
        if let email = try? container.decode(String.self, forKey: .email) {
            self.email = email
        }
        
        if let equiLabel = try? container.decode(String.self, forKey: .equiLabel) {
            self.equiLabel = equiLabel
        }
        
        if let firstName = try? container.decode(String.self, forKey: .firstName) {
            self.firstName = firstName
        }
        
        if let imei = try? container.decode(String.self, forKey: .imei) {
            self.imei = imei
        }
        
        if let lastName = try? container.decode(String.self, forKey: .lastName) {
            self.lastName = lastName
        }
        
        if let phoneNumber = try? container.decode(String.self, forKey: .phoneNumber) {
            self.phoneNumber = phoneNumber
        }
        
        if let sex = try? container.decode(String.self, forKey: .sex) {
            self.sex = sex
        }
        
        if let street0 = try? container.decode(String.self, forKey: .street0) {
            self.street0 = street0
        }
        
        
        if let OfIdent = try? container.decode(String.self, forKey: .OfIdent) {
            self.OfIdent = OfIdent
        }
        
        if let modelo = try? container.decode(String.self, forKey: .modelo) {
            self.modelo = modelo
        }
        
        if let marca = try? container.decode(String.self, forKey: .marca) {
            self.marca = marca
        }
        
        if let version = try? container.decode(String.self, forKey: .version) {
            self.version = version
        }
        
        if let juzgado = try? container.decode(String.self, forKey: .juzgado) {
            self.juzgado = juzgado
        }
        
        if let causante = try? container.decode(String.self, forKey: .causante) {
            self.causante = causante
        }
        
        if let cautelar = try? container.decode(String.self, forKey: .cautelar) {
            self.cautelar = cautelar
        }
        
        
        if let userExists = try? container.decode(String.self, forKey: .userExists) {
            self.userExists = userExists
        }
        
        if let street1 = try? container.decode(String.self, forKey: .street1) {
            self.street1 = street1
        }
        
        if let street2 = try? container.decode(String.self, forKey: .street2) {
            self.street2 = street2
        }
        
        if let province = try? container.decode(String.self, forKey: .province) {
            self.province = province
        }
        
        if let department = try? container.decode(String.self, forKey: .department) {
            self.department = department
        }
        
        if let city = try? container.decode(String.self, forKey: .city) {
            self.city = city
        }
        
        if let district = try? container.decode(String.self, forKey: .district) {
            self.district = district
        }
        
        
        if let floor = try? container.decode(String.self, forKey: .floor) {
            self.floor = floor
        }
        
        if let body = try? container.decode(String.self, forKey: .body) {
            self.body = body
        }
        
        if let block = try? container.decode(String.self, forKey: .block) {
            self.block = block
        }
        
        if let plat = try? container.decode(String.self, forKey: .plat) {
            self.plat = plat
        }
        
        if let houseNumber = try? container.decode(String.self, forKey: .houseNumber) {
            self.houseNumber = houseNumber
        }
        
        if let door = try? container.decode(String.self, forKey: .door) {
            self.door = door
        }
        
        if let subcliente = try? container.decode(String.self, forKey: .subcliente) {
            self.subcliente = subcliente
        }
        
        
        
        
        
        
        
        let container2 = try decoder.container(keyedBy: DecodingKeys.self)
        if let country = try? container2.decode(String.self, forKey: .country) {
            self.country = country
        }
        
        if let docNumber = try? container2.decode(String.self, forKey: .docNumber) {
            self.docNumber = docNumber
        }
        
        if let docType = try? container2.decode(String.self, forKey: .docType) {
            self.docType = docType
        }
        
        if let email = try? container2.decode(String.self, forKey: .email) {
            self.email = email
        }
        
        if let equiLabel = try? container2.decode(String.self, forKey: .equiLabel) {
            self.equiLabel = equiLabel
        }
        
        if let firstName = try? container2.decode(String.self, forKey: .firstName) {
            self.firstName = firstName
        }
        
        if let imei = try? container2.decode(String.self, forKey: .imei) {
            self.imei = imei
        }
        
        if let lastName = try? container2.decode(String.self, forKey: .lastName) {
            self.lastName = lastName
        }
        
        if let phoneNumber = try? container2.decode(String.self, forKey: .phoneNumber) {
            self.phoneNumber = phoneNumber
        }
        
        if let sex = try? container2.decode(String.self, forKey: .sex) {
            self.sex = sex
        }
        
        if let street0 = try? container2.decode(String.self, forKey: .street0) {
            self.street0 = street0
        }
        
        
        
        if let OfIdent = try? container2.decode(String.self, forKey: .OfIdent) {
            self.OfIdent = OfIdent
        }
        
        if let modelo = try? container2.decode(String.self, forKey: .modelo) {
            self.modelo = modelo
        }
        
        if let marca = try? container2.decode(String.self, forKey: .marca) {
            self.marca = marca
        }
        
        if let version = try? container2.decode(String.self, forKey: .version) {
            self.version = version
        }
        
        if let juzgado = try? container2.decode(String.self, forKey: .juzgado) {
            self.juzgado = juzgado
        }
        
        if let causante = try? container2.decode(String.self, forKey: .causante) {
            self.causante = causante
        }
        
        if let cautelar = try? container2.decode(String.self, forKey: .cautelar) {
            self.cautelar = cautelar
        }
        
        
        if let userExists = try? container2.decode(String.self, forKey: .userExists) {
            self.userExists = userExists
        }
        
        if let street1 = try? container2.decode(String.self, forKey: .street1) {
            self.street1 = street1
        }
        
        if let street2 = try? container2.decode(String.self, forKey: .street2) {
            self.street2 = street2
        }
        
        if let province = try? container2.decode(String.self, forKey: .province) {
            self.province = province
        }
        
        if let department = try? container2.decode(String.self, forKey: .department) {
            self.department = department
        }
        
        if let city = try? container2.decode(String.self, forKey: .city) {
            self.city = city
        }
        
        if let district = try? container2.decode(String.self, forKey: .district) {
            self.district = district
        }
        
        
        if let floor = try? container2.decode(String.self, forKey: .floor) {
            self.floor = floor
        }
        
        if let body = try? container2.decode(String.self, forKey: .body) {
            self.body = body
        }
        
        if let block = try? container2.decode(String.self, forKey: .block) {
            self.block = block
        }
        
        if let plat = try? container2.decode(String.self, forKey: .plat) {
            self.plat = plat
        }
        
        if let houseNumber = try? container2.decode(String.self, forKey: .houseNumber) {
            self.houseNumber = houseNumber
        }
        
        if let door = try? container2.decode(String.self, forKey: .door) {
            self.door = door
        }
        
    }
    
    init(dictionary: [String: Any]) {
        self.country = dictionary["country"] as? String
        self.docNumber = dictionary["docNumber"] as? String
        self.docType = dictionary["docType"] as? String
        self.email = dictionary["email"] as? String
        self.equiLabel = dictionary["equiLabel"] as? String
        self.firstName = dictionary["firstName"] as? String
        self.imei = UserDataHelper.getId()
        self.lastName = dictionary["lastName"] as? String
        self.phoneNumber = dictionary["phoneNumber"] as? String
        self.sex = dictionary["sex"] as? String
        self.street0 = dictionary["street0"] as? String
        
        self.OfIdent = dictionary["OfIdent"] as? String
        self.juzgado = dictionary["juzgado"] as? String
        self.causante = dictionary["causante"] as? String
        self.cautelar = dictionary["cautelar"] as? String
        self.userExists = dictionary["userExists"] as? String
        self.street1 = dictionary["street1"] as? String
        self.street2 = dictionary["street2"] as? String
        self.province = dictionary["province"] as? String
        self.department = dictionary["department"] as? String
        self.city = dictionary["city"] as? String
        self.district = dictionary["district"] as? String
        self.floor = dictionary["floor"] as? String
        self.body = dictionary["body"] as? String
        self.block = dictionary["block"] as? String
        self.plat = dictionary["plat"] as? String
        self.houseNumber = dictionary["houseNumber"] as? String
        self.door = dictionary["door"] as? String
        self.subcliente = dictionary["subcliente"] as? String
                


        self.modelo = UIDevice.modelName
        self.marca = "Apple"
        self.version = UIDevice().systemVersion
        
        
        
    }
    
    
}
