//
//  TerminosCondicionesSerivce.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 10/07/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class TerminosCondicionesService {
    private let url = Constants.API_URL
    
    public func get() -> Observable<String> {
        return RxAlamofire.requestData(.get, self.url + "mock/termsAndConditions.php").map { response, text in
            return String(decoding: text, as: UTF8.self)
        }
    }
    
}
