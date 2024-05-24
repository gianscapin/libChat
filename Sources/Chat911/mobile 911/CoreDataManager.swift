//
//  CoreDataManager.swift
//  mobile 911
//
//  Created by Ezequiel Zarate on 30/01/2022.
//  Copyright © 2022 Soflex. All rights reserved.
//

import Foundation
import CoreLocation
import CoreData
import UIKit


class CoreDataManager {
    //2
    var lastLocation = CLLocation()
    
    private let container : NSPersistentContainer!
    //3
    init() {
        container = NSPersistentContainer(name: "Banking")
        
        setupDatabase()
    }
    
    private func setupDatabase() {
        //4
        container.loadPersistentStores { (desc, error) in
        if let error = error {
            print("Error loading store \(desc) — \(error)")
            return
        }
        print("Database ready!")
        
        }
    }
    
    func updateLocation(location : CLLocation) {
        self.lastLocation = location
    }
    
    func createEvent(type:TipoEnvio, e: TipoEvento) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let dateString = formatter.string(from:Date())
        
        
        let lat = Double(round(100000 * self.lastLocation.coordinate.latitude)/100000)
        let lon = Double(round(100000 * self.lastLocation.coordinate.longitude)/100000)
        
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = UIDevice.current.batteryLevel * 100
        

        let context = container.viewContext
       
        let evento = Evento(context: context)
        evento.id = UIDevice.current.identifierForVendor?.uuidString ?? "null"
        evento.date = dateString
        evento.lat = lat
        evento.lon = lon
        evento.speed = lastLocation.speed
        evento.bearing = lastLocation.course
        evento.acc = lastLocation.horizontalAccuracy
        evento.bat = batteryLevel
        evento.type = Int16(type.rawValue)
        evento.evento = Int16(e.rawValue)
        evento.online = 1
        evento.enviado = false
        evento.fecha = Date()
        
        

        do {
            try context.save()
        } catch {
            print("Error guardando evento — \(error)")
        }
        
        
    }
    
    
    
    func fetchEventosNoEnviados() -> [Evento] {
        let fetchRequest: NSFetchRequest<Evento> = Evento.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(
            format: "enviado = %@", NSNumber(value: false)
        )
       
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo evento(s) \(error)")
        }
        
        return []
    }
    
    
    func fetchPanico() -> [Evento] {
        let fetchRequest: NSFetchRequest<Evento> = Evento.fetchRequest()
        
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                NSPredicate(
                    format: "evento = %@", TipoEvento.PANICO.rawValue
                ),
                NSPredicate(
                    format: "enviado = %@", NSNumber(value: false)
                )
            ]
        )
        
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print("El error obteniendo evento(s) \(error)")
        }
        
        return []
    }
    
    
    func deleteEventos() {
        
    }
    
    func editarEvento(evento: Evento, enviado: Bool, online: Int16) {
        let context = container.viewContext
        
        
        evento.enviado = enviado
        evento.online = online
        evento.fechaModificacion = Date()
        
        do {
            try context.save()
        } catch {
            print("Error guardando evento — \(error)")
        }
        
    }
    
    
    
    
    
    
}
