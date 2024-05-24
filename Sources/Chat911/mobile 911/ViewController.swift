//
//  ViewController.swift
//  mobile 911
//
//  Created by Fernando Cerini on 31/10/2018.
//  Copyright © 2018 Soflex. All rights reserved.
//

import UIKit
import CoreLocation
import MessageUI
import MapKit
import RxSwift
import Reachability
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController , CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
   
    
    
    
    @IBOutlet weak var testigoGPS: TestigoControl!
    
    @IBOutlet weak var rootView: UIView!
    
    @IBOutlet weak var testigoRED: TestigoControl!
    
    @IBOutlet weak var btLlamar: UIButton!
    
    @IBOutlet weak var btChat: UIButton!
    
    @IBOutlet weak var btVideo: UIButton!
    
    @IBOutlet weak var testigoPanico: UIView!
    @IBOutlet weak var testigoTexto: UILabel!
    
    private let manager = CoreDataManager()
    
    let cargandoConfiguracion: UIAlertController = UIAlertController(title: "Cargando, Espere...", message: nil, preferredStyle: .alert);
    
    var zone: Zone? = nil
    
    let locationManager = CLLocationManager()
    var lastLocation = CLLocation()
    var lastLocationSended = CLLocation()
    var lastDate = NSDate()
    var positionReport: Int = Int(UserDefaults.standard.getConfig()?.reportConfig.positionReport ?? 3600)
    var lastPositionReport: Int = Int(UserDefaults.standard.getConfig()?.reportConfig.panicReport ?? 60)
    var arrayEvent = [Event]()
    static var LAST_POSITION_TIME_REPORT = 0
    
    let panicoService = PanicoService()
    
    static var lastLat = "0"
    static var lastLon = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(forName: UIApplication.didBecomeActiveNotification, object: nil, queue: nil) { _ in
            self.setupGPS()
        }
        
        self.testigoPanico.layer.cornerRadius = 10
        
        createCargando()
        
        getConfig()
        showButtons()
        
        subscribeTestigo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        networkState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupGPS()
    }
    
    private func subscribeTestigo() {
        
       panicoService.subject.asObservable().subscribe(onNext: { estadoPanico in

        switch estadoPanico.estadoPanico {
            case .NONE:
                self.testigoPanico.isHidden = true
            case .ENVIADO:
                self.testigoPanico.isHidden = false
                self.testigoTexto.text = estadoPanico.descipcion
                self.testigoPanico.backgroundColor = .systemYellow
            case .RECIBIDO:
                self.testigoPanico.isHidden = false
                self.testigoTexto.text = estadoPanico.descipcion
                self.testigoPanico.backgroundColor = .systemRed
            }
        })
        
        
    }
    
    
    private func createCargando() {
//        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.style = UIActivityIndicatorView.Style.gray
//        loadingIndicator.startAnimating();
//        cargandoConfiguracion.view.addSubview(loadingIndicator)
//        present(cargandoConfiguracion, animated: true, completion: nil)
    }
    
    private func dismissCargando() {
//        DispatchQueue.main.async {
//            if (self.cargandoConfiguracion.isViewLoaded) {
//                self.cargandoConfiguracion.dismiss(animated: true, completion: nil)
//            }
//        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: ACTIONS
    
    var alarm = -1;
    var timer: Timer?
    let interval = Double(UserDefaults.standard.getConfig()?.reportConfig.positionReport ?? 60)
    
    
    @IBAction func btLlamarClick(_ sender: Any) {
        initAlarm()
        call()
    }
    
    @IBAction func misDatosClick(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let settingsViewController = storyBoard.instantiateViewController(withIdentifier: "datos") as! SettingsViewController
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func clickVideo(_ sender: UIButton) {
        
        let newViewController = VideoChatViewController()
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    
    @IBAction func gpsClick(_ sender: Any) {
        openSettings()
    }
    
    func openSettings() {
        if let configuraciones = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(configuraciones, options: [:], completionHandler: nil)
        }
    }
    
}

//MARK: GPS
extension ViewController {
    
    
    func setupGPS() {
        
        
        enableLocationServices()
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            
            setEstado(estadoGPS: .DISABLE)
            
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            
            setEstado(estadoGPS: .DISABLE)
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        //        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
        
        
        setEstado(estadoGPS: .OK)
        setEstado(estadoRED: .OK)
    }

    func requestPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
                    
                    // Now that we are authorized we can get the IDFA
                    print(ASIdentifierManager.shared().advertisingIdentifier)
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    func enableLocationServices() {
        locationManager.delegate = self
        
        requestPermission()

        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestAlwaysAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            print ("Location restricted, denied")
            break
            
        case .authorizedWhenInUse:
            // Enable basic location features
            print ("Location authorizedWhenInUse")
            break
            
        case .authorizedAlways:
            // Enable any of your app's location features
            print ("Location authorizedAlwayss")
            break
        }
    }
    
    private func networkState() {
        let reachability = try! Reachability()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            let randomNumber = Int.random(in: 1...20)
            print("Number: \(randomNumber)")
            self.reachabilityChanged()
//            self.subscribeTestigo()

            let eventos = self.manager.fetchEventosNoEnviados()
            if(!eventos.isEmpty) {
                self.sendEvents(eventos: eventos)
            }
            
        }
    }
    
    private func changeReport() {
        lastPositionReport = positionReport
        positionReport = Int(UserDefaults.standard.getConfig()!.reportConfig.panicReport) 
        Timer.scheduledTimer(withTimeInterval: TimeInterval(Double(UserDefaults.standard.getConfig()?.reportConfig.panicReportTime ?? 3600) ), repeats: true) { timer in
            self.positionReport = self.lastPositionReport
            self.lastPositionReport = Int(UserDefaults.standard.getConfig()!.reportConfig.panicReport) 
        }
    }
    
    @objc func reachabilityChanged() {
        let reachability = try! Reachability()
        
//        switch reachability?.connection {
//        case .some(.none):
//            self.setEstado(estadoRED: .DISABLE)
//        default:
//            self.setEstado(estadoRED: .OK)
//        }
    }
    
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
        print("New Position")
        
   
        self.manager.updateLocation(location: lastLocation)
        
        let point = Point(x: String(round(100000 * self.lastLocation.coordinate.longitude)/100000), y: String(round(100000 * self.lastLocation.coordinate.latitude)/100000))
        if(self.zone != nil) {
            let isInZone = self.zone?.inPolygon(test: point)
            if(isInZone!) {
                print("Estoy dentro")
                showButtons()
            } else {
                print("Estoy Fuera")
//                self.rootView.view(withId: "btnChat")?.isHidden = true;
            }
        }
        
        let type = shouldSendPosition()
        if (type > 0){
            print("Posicion para evniar")
            sendPosition(type: type)
            lastLocationSended = lastLocation
            lastDate = NSDate()
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            
            setEstado(estadoGPS: .DISABLE)
            
            return
        }
        print (error.localizedDescription)
    }
    
}

//MARK: PANIC
extension ViewController {
    
    func sendPosition(type: Int) {
        print("enviando posicion")
        sendEvent(type: TipoEnvio.MOVIMIENTO, e: TipoEvento.POSICION)
        
    }
    
    /**
     * Return: type
     * 0 no enviar
     * 1 movimiento
     * 2 tiempo
     * 3 muchas posiciones
     */
    func shouldSendPosition() -> Int{
        var send = 0
        
        let elapsed = NSDate().timeIntervalSince(self.lastDate as Date)
        if(Int(elapsed) > positionReport) {
            send = 1
        }
        
        return send
        
        
    }
    
    
    func sendEvent(type:TipoEnvio, e: TipoEvento) {
        self.manager.createEvent(type: type, e: e)
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"
//        let dateString = formatter.string(from:Date())
//
//        let lat = Double(round(100000 * self.lastLocation.coordinate.latitude)/100000)
//        let lon = Double(round(100000 * self.lastLocation.coordinate.longitude)/100000)
//
//        UIDevice.current.isBatteryMonitoringEnabled = true
//        let batteryLevel = UIDevice.current.batteryLevel * 100
//
//        var event = Event(
//            id: UIDevice.current.identifierForVendor?.uuidString ?? "null",
//            date: dateString,
//            lat: lat,
//            lon: lon,
//            speed: lastLocation.speed,
//            bearing: lastLocation.course,
//            acc: lastLocation.horizontalAccuracy,
//            bat: batteryLevel,
//            type: type.rawValue,
//            evento: e.rawValue,
//            online: 1)
//
//        if (e == TipoEvento.PANICO) {
//            panicoService.set(estadoPanico: EstadoPanico.ENVIADO)
//        }
//        EventosService().send(evento: event)
//            .subscribe(onNext: { config in
//                print("Evento Enviado" + dateString)
//                self.setEstado(estadoRED: EstadoRED.OK)
//                if (e == TipoEvento.PANICO) {
//                    self.panicoService.set(estadoPanico: EstadoPanico.RECIBIDO, interval: Double(UserDefaults.standard.getConfig()?.reportConfig.panicReportTime ?? 60) )
//                }
//            }, onError: { error in
//                event.online = 0
//                self.arrayEvent.append(event)
//                print("No se envio el evento, se encola" + dateString)
//                self.setEstado(estadoRED: EstadoRED.ERROR)
//            })
        
    }
    
    
    func sendEvents(eventos: [Evento]) {
        for evento in eventos {
            var event = Event(evento: evento)
            if(evento.type == TipoEvento.PANICO.rawValue) {
                panicoService.set(estadoPanico: EstadoPanico.ENVIADO)
            }
            
            EventosService().send(evento: event)
                      .subscribe(onNext: { config in
                          if (evento.type == TipoEvento.PANICO.rawValue) {
                              self.panicoService.set(estadoPanico: EstadoPanico.RECIBIDO, interval: Double(UserDefaults.standard.getConfig()?.reportConfig.panicReportTime ?? 60) )
                          }
                          
                          self.manager.editarEvento(evento: evento, enviado: true, online: 0)
                          print("Evento Enviado")
                          self.setEstado(estadoRED: EstadoRED.OK)
                      }, onError: { error in
                          self.manager.editarEvento(evento: evento, enviado: false, online: 0)
                          print("No se envio el evento, se encola")
                          self.setEstado(estadoRED: EstadoRED.ERROR)
                      })
            
        }
    }
    
    func eachSecond() {
        
        if (alarm == 1) {
            print ("En Llamada")
            btLlamar.setTitle("EN Llamada!", for: .normal)
            timer?.invalidate()
            
            initAlarm()
            call()
            
        } else if (alarm > 1){
            btLlamar.setTitle("LLAMANDO EN \(alarm)", for: .normal)
            alarm -= 1
        }
    }
    
    func cancelAlarm(){
        
        let cancelAlert = UIAlertController(title: "Cancelar la llamada", message: "Esta seguro que quiere cancelar la llamada?.", preferredStyle: UIAlertController.Style.alert)
        
        cancelAlert.addAction(UIAlertAction(title: "SI", style: .default, handler: { (action: UIAlertAction!) in
            
            self.alarm = -1
            self.timer?.invalidate()
            
            self.btLlamar.backgroundColor = UIColor.darkGray
            self.btLlamar.setTitle("Llamar", for: .normal)
            
        }))
        
        cancelAlert.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { (action: UIAlertAction!) in
            print("no pasa nada")
        }))
        
        present(cancelAlert, animated: true, completion: nil)
        
    }
    
    func call() {
        if let url = URL(string: "tel://\(UserDefaults.standard.getConfig()!.phoneNumber)"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func initAlarm(){
        print ("Enviando ALARMA")
        sendSMS()
        self.sendEvent(type: TipoEnvio.OTRO, e: TipoEvento.PANICO)
    }
    
    private func sendSMS() {
        if let numeroSMS = UserDefaults.standard.getConfig()?.messageConfig.smsNumber,
           let mensaje = UserDefaults.standard.getConfig()?.messageConfig.smsTemplatePanic {
            var recipients = [numeroSMS]
            
            if let contacto = UserDefaults.standard.getContacto() {
                recipients = contacto.toArray(number: numeroSMS)
            }
     
            let mess = replaceText(string: mensaje)
            if (MFMessageComposeViewController.canSendText()) {
                        let controller = MFMessageComposeViewController()
                        controller.body = mess
                        controller.recipients = recipients
                        controller.messageComposeDelegate = self
                        self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    private func replaceText(string: String) -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        
        let lat = String(format: "%f", Double(round(100000 * self.lastLocation.coordinate.latitude)/100000))
        let lon = String(format: "%f",Double(round(100000 * self.lastLocation.coordinate.longitude)/100000))
        
        return string.replacingOccurrences(of: "{yyyyMMddHHmmss}", with: dateFormatter.string(from: date), range: nil)
            .replacingOccurrences(of: "{imei}", with: UserDefaults.standard.getUsuario()?.imei ?? "", range: nil)
            .replacingOccurrences(of: "{longitude}", with: lon, range: nil)
            .replacingOccurrences(of: "{latitude}", with: lat, range: nil)
            .replacingOccurrences(of: "{userfirstName}", with: UserDefaults.standard.getUsuario()?.firstName ?? "", range: nil)
            .replacingOccurrences(of: "{userLastName}", with: UserDefaults.standard.getUsuario()?.lastName ?? "", range: nil)
            .replacingOccurrences(of: "{userPhoneNumber}", with: UserDefaults.standard.getUsuario()?.phoneNumber ?? "", range: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)

    }
    

    
    private func setEstado(estadoGPS: EstadoGPS) {
        switch estadoGPS {
        case .OK:
            testigoGPS.setTestigo(testigo: Testigo(id: 1, texto: "OK", icon: UIImage(named: "gps-ok")!, color: UIColor().fromHexColor(hex: "#f5f5f5")!))
            break
        case .DISABLE:
            testigoGPS.setTestigo(testigo: Testigo(id: 1, texto: "OFF", icon: UIImage(named: "gps-off")!, color: UIColor().fromHexColor(hex: "#e76056")!))
            break
        case .ERROR:
            testigoGPS.setTestigo(testigo: Testigo(id: 1, texto: "ERROR", icon: UIImage(named: "gps-stop")!, color: UIColor().fromHexColor(hex: "#fcda59")!))
            break
        }
    }
    
    private func setEstado(estadoRED: EstadoRED) {
        switch estadoRED {
        case .OK:
            testigoRED.setTestigo(testigo: Testigo(id: 1, texto: "OK", icon: UIImage(named: "wifi-ok")!, color: UIColor().fromHexColor(hex: "#f5f5f5")!))
            break
        case .DISABLE:
            testigoRED.setTestigo(testigo: Testigo(id: 1, texto: "OFF", icon: UIImage(named: "wifi-off")!, color: UIColor().fromHexColor(hex: "#e76056")!))
            break
        case .ERROR:
            testigoRED.setTestigo(testigo: Testigo(id: 1, texto: "SIN RED", icon: UIImage(named: "wifi-error")!, color: UIColor().fromHexColor(hex: "#fcda59")!))
            break
        }
    }
    
    
    
    func getConfig() {
        ConfigDataHelper.getConfig()
            .subscribe(onNext: { config in
                UserDefaults.standard.setConfig(config: config)
                if(config.area != "") {
                    self.zone = Zone(wkt: config.area)
                }
                self.dismissCargando();
            }, onError: { error in
                self.dismissCargando();
                self.errorConfig()
            })
    }
    
    private func errorConfig() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "No se cargo correctamente la configuracion del boton de panico", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: { action in
                self.getConfig()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func showButtons() {
        self.rootView.view(withId: "btnChat")?.isHidden = true;
        self.rootView.view(withId: "btnVideo")?.isHidden = true;
        self.rootView.view(withId: "btnSOS")?.isHidden = false;
        self.rootView.view(withId: "btnSOS")?.backgroundColor = UIColor().fromHexColor(hex: "#e12e36")
        
        UserDefaults.standard.getConfig()?.buttons.forEach({ (buttonString: String) in
            let button = self.rootView.view(withId: buttonString)
            if( button != nil) {
                button!.isHidden = false;
            }
        })
    }
    
    
    
    
    
    
}
