//
//  ApiHelper.swift
//  mobile 911
//
//  Created by Fernando Cerini on 23/11/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import Foundation
import RxSwift

class Constants {
    public static let API_URL = (Bundle.main.infoDictionary?["BaseUrl"] as! String)
    public static let POSITION_URL = (Bundle.main.infoDictionary?["PositionUrl"] as! String)
    public static let REGISTRATION_PASSWORD = (Bundle.main.infoDictionary?["RegistrationPassword"] as! String)
    public static let EMERGENCY_NUMBER = UserDefaults.standard.getConfig()?.phoneNumber
    public static let ID_CLIENTE = (Bundle.main.infoDictionary?["IdCliente"] as! String)
    
}

class ApiHelper {
    static func postRequest(php: String) -> URLRequest {
        let url = URL(string: Constants.API_URL + php)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.getSubliente(), forHTTPHeaderField: "id-subcliente")
        request.setValue(Constants.ID_CLIENTE, forHTTPHeaderField: "id-cliente")
        return request
    }
    
    static func postMultipartRequest(php: String) -> URLRequest {
        let url = URL(string: Constants.API_URL + php)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(UserDefaults.standard.getSubliente(), forHTTPHeaderField: "id-subcliente")
        request.setValue(Constants.ID_CLIENTE, forHTTPHeaderField: "id-cliente")
        return request
    }
    
    static func getRequest(php: String) -> URLRequest {
        let url = URL(string: Constants.API_URL + php)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.getSubliente(), forHTTPHeaderField: "id-subcliente")
        request.setValue(Constants.ID_CLIENTE, forHTTPHeaderField: "id-cliente")
        return request
    }
}



class ApiHelper2<T: Codable> {
    
    static func getRequest(url: String) -> URLRequest {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.getSubliente(), forHTTPHeaderField: "id-subcliente")
        request.setValue(Constants.ID_CLIENTE, forHTTPHeaderField: "id-cliente")
        return request
    }
    
    static func postRequest(url: String) -> URLRequest {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDefaults.standard.getSubliente(), forHTTPHeaderField: "id-subcliente")
        request.setValue(Constants.ID_CLIENTE, forHTTPHeaderField: "id-cliente")
        return request
    }
    
    func get(url: String) -> Observable<T> {
        return Observable.create { observer in
            let request = ApiHelper2.getRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                if let error = error {
//                    print ("error: \(error)")
                    observer.on(.error(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
//                        print ("server error")
                        observer.on(.error(NSError()))
                        return
                }
                
                if let data = data,
                   let dataString = String(data: data, encoding: .utf8) {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(Formatter.fecha)
                    
                    do {
                        let response = try decoder.decode(T.self, from: data)
                        observer.on(.next(response))
                    } catch let error as DecodingError {
                        switch error {
                        case .keyNotFound(let key, let context):
                            print("Missing key: \(key.stringValue) in context: \(context.debugDescription)")
                        case .typeMismatch(let type, let context):
                            print("Type mismatch for type \(type) in context: \(context.debugDescription)")
                        case .valueNotFound(let type, let context):
                            print("Value not found for type \(type) in context: \(context.debugDescription)")
                        case .dataCorrupted(let context):
                            print("Data corrupted in context: \(context.debugDescription)")
                        @unknown default:
                            print("Unknown decoding error")
                        }
                        observer.on(.error(error))
                    } catch {
                        print("Unexpected error: \(error.localizedDescription)")
                        observer.on(.error(error))
                    }
                    // print("data: \(dataString)")
                }

                
            }
            task.resume()
            
            //            observer.on(.completed)
            return Disposables.create()
        }
    }
    
    
    func post(url: String, body: Data) -> Observable<T> {
        return Observable.create { observer in
            let request = ApiHelper2.postRequest(url: url)
            
            let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
                
                if let error = error {
                    print ("error: \(error)")
                    observer.on(.error(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                        print ("server error")
                        observer.on(.error(NSError()))
                        return
                }
                
                if  let data = data,
                    let dataString = String(data: data, encoding: .utf8)
                {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(Formatter.fecha)
                    let response = try! decoder.decode(T.self, from: data)
                    observer.on(.next(response))
                    print ("data: \(dataString)")
                }
                
            }
            task.resume()
            
            //            observer.on(.completed)
            return Disposables.create()
        }
    }
}
