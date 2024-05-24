//
//  UserDataExtension.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 21/02/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation

extension UserDefaults {
    func setConfig(config: Config) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(config) {
            set(encoded, forKey: UserTypeData.Config.rawValue)
        }
    }
    
    func getConfig() -> Config? {
        let decoder = JSONDecoder()
        if let configData = object(forKey: UserTypeData.Config.rawValue) as? Data,
            let config = try? decoder.decode(Config.self, from: configData) {
            return config
        } else {
            return nil
        }
    }
    
    func getUsuario() -> Usuario? {
       let decoder = JSONDecoder()
       if let usuarioData = object(forKey: UserTypeData.Usuario.rawValue) as? Data,
           let config = try? decoder.decode(Usuario.self, from: usuarioData) {
           return config
       } else {
            return nil
       }
        
        
    }
    
    func setContacto(contacto: Contacto) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contacto) {
            set(encoded, forKey: UserTypeData.Contacto.rawValue)
        }
    }
    
    func getContacto() -> Contacto? {
        let decoder = JSONDecoder()
        if let data = object(forKey: UserTypeData.Contacto.rawValue) as? Data,
            let contacto = try? decoder.decode(Contacto.self, from: data) {
            return contacto
        } else {
             return nil
        }
    }
    
    func setUsuario(usuario: Usuario) {
        
        if(usuario.subcliente != nil) {
            setSubliente(subcliente: usuario.subcliente!)
        }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(usuario) {
            set(encoded, forKey: UserTypeData.Usuario.rawValue)
        }
    }
    
    func removeUsuario() {
        removeObject(forKey: UserTypeData.Usuario.rawValue)
    }
    
    func getSubliente() -> String {
        return object(forKey: UserTypeData.Subcliente.rawValue) == nil ? "" : object(forKey: UserTypeData.Subcliente.rawValue) as! String
    }
    
    func setSubliente(subcliente: String) {
        set(subcliente, forKey: UserTypeData.Subcliente.rawValue)
    }
    
}


private enum UserTypeData: String  {
    case Config = "config"
    case Usuario = "usuario"
    case Subcliente = "subcliente"
    case Contacto = "contacto"
}
