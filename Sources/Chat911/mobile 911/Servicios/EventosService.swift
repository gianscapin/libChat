//
//  EventosService.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 14/05/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class EventosService {
    
    private let url = Constants.POSITION_URL
    
    private var eventosEncolados: [Event] = [Event]()
    
    public func send(evento: Event) -> Observable<Bool> {
        let header = HTTPHeaders([HTTPHeader(name: "content-type",value: "application/json")])
        return RxAlamofire.requestData(.post, self.url, parameters: evento.dictionary,encoding: JSONEncoding.default, headers: header)
            .map { response, json in
                return true
            }.retryWhen { errors in
                errors.flatMap {error -> Observable<Error> in
                    if (evento.evento == TipoEvento.PANICO.rawValue) {
                        return Observable.just(error)
                    } else {
                        return Observable.error(error)
                    }
                }
            }
            .catchError { error -> Observable<Bool> in
                var e = evento;
                e.online = TipoConexion.OFFLINE.rawValue
                print(e)
                self.eventosEncolados.append(e)
                return Observable.of(false)
            }
        }
}

enum TipoEvento: Int {
    case PANICO = 99
    case POSICION = 1
    case BATERIA_BAJA = 2
}

enum TipoEnvio: Int {
    case NO_ENVIAR = 0
    case MOVIMIENTO = 1
    case TIEMPO = 2
    case DESBORDAMIENTO = 3
    case OTRO = 99
}

enum TipoConexion: Int {
    case ONLINE = 1
    case OFFLINE = 0
}
/*
 Observable.from(eventosEncolados + [evento]).flatMap { e -> Observable<Bool> in
 print(e)
 return
 */
