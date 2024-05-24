//
//  LocalDataHelper.swift
//  mobile 911
//
//  Created by Fernando Cerini on 05/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit
import RxSwift

class UserDataHelper {
    
    static private let defaults = UserDefaults.standard
    
    
    static func getId() -> String{

                
        if(getImei() != "") {
            return getImei()
        } else {
            return UIDevice.current.identifierForVendor?.uuidString ?? ""
            
//            return "480F05AE-499C-4B2F-AE3D-9839C73EEB8XXXkkkXXx"
        }

    }
    
    
    static func isRegistrado() -> Observable<Bool>  {
        return getRegistroServidor().map { value in
            return UserDefaults.standard.getUsuario()?.firstName != nil
        }.catchError { error in
            return Observable.from(optional: true)
        }
    }
    
    
    static func setImei(imei: String) {
        UserDefaults.standard.set(imei, forKey: "imei")
    }


    // Para recuperar el valor de UserDefaults
    static func getImei() -> String {
        return UserDefaults.standard.string(forKey: "imei") ?? ""
    }

    
    // Devuelve True si hubo un cambio en el usuario!
    private static func getRegistroServidor() -> Observable<Bool> {

        let json = GetUserInfo( method: "getUserInfo", id: self.getId())
        guard let uploadData = try? JSONEncoder().encode(json) else {
            return Observable.from(optional: false)
        }
        
        return ApiHelper2<RespuestaUsuario>().post(url: Constants.API_URL + "usuario.php", body: uploadData).map({ respuestaUsuario in
            UserDefaults.standard.removeUsuario()
            if let usuario = respuestaUsuario.output {
                UserDefaults.standard.setUsuario(usuario: usuario)
                return true
            }
            return false
        })
        
    }
}
