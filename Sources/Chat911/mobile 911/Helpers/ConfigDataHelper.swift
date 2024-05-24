//
//  ConfigDataHelper.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 02/03/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class ConfigDataHelper {
    
    
    public static func getConfig() -> Observable<Config> {
        return  ApiHelper2<Config>().get(url: Constants.API_URL + "mock/config.php")
            .catchError({ (observable) -> Observable<Config> in
                if let config = UserDefaults.standard.getConfig() {
                    return Observable.of(config)
                } else {
                    throw NSError()
                }
            })
    }
    
}
