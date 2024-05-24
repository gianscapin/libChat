//
//  PanicoService.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 10/07/2020.
//  Copyright © 2020 Soflex. All rights reserved.
//

import Foundation
import RxSwift

class PanicoService {
    
    public let subject = BehaviorSubject(value: PanicoDescripcion(estadoPanico: .NONE, descipcion: ""))

    
    func set(estadoPanico: EstadoPanico, interval: Double = 60.0) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        switch estadoPanico {
        case .NONE:
            self.subject.onNext(PanicoDescripcion(estadoPanico: .NONE, descipcion: ""))
        case .ENVIADO:
            self.subject.onNext(PanicoDescripcion(estadoPanico: .ENVIADO, descipcion: "Panico Enviado " + formatter.string(from: Date())))
        case .RECIBIDO:
            self.subject.onNext(PanicoDescripcion(estadoPanico: .RECIBIDO, descipcion: "Panico Recibido " + formatter.string(from: Date()) ))
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                self.subject.onNext(PanicoDescripcion(estadoPanico: .NONE, descipcion: ""))
            }
        }
    }
    
    
    func getEstado() -> Observable<PanicoDescripcion> {
        return subject.asObservable()
    }
}


enum EstadoPanico {
    case NONE
    case ENVIADO
    case RECIBIDO
}

struct PanicoDescripcion {
    public let estadoPanico: EstadoPanico
    public let descipcion: String
    
}
