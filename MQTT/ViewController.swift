import UIKit
import CocoaMQTT

class ViewController: UIViewController {

    private var mqtt: CocoaMQTT!
    var light : Int = 0
    var switch_ : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        createMQTTConnection()
////        simpleSSLSetting()
////        selfSignedSSLSetting()
//        simpleSSLSetting()
//
       
    }
    
    @IBOutlet weak var label: UILabel!
    
    @IBAction func SwitchLight(_ sender: UISwitch) {
        if(sender.isOn == true) {
            label.text = "Light Is On"
            light = 1
//            createMQTTConnection()
            simpleSSLSetting()
            print("tangina shit:" , light)
        }else {
//            createMQTTConnection()
            simpleSSLSetting()
            label.text = "Light Is Off"
            light = 0
            print("tangina shit1:" , light)
        }
    }
    
    @IBAction func publishshit(_ sender: Any) {
      simpleSSLSetting()
      createMQTTConnection()

    }
    func getClientCertFromP12File(certName: String, certPassword: String) -> CFArray? {
        // get p12 file path
        let resourcePath = Bundle.main.path(forResource: certName, ofType: "p12")
        
        guard let filePath = resourcePath, let p12Data = NSData(contentsOfFile: filePath) else {
            print("Failed to open the certificate file: \(certName).p12")
            return nil
        }
        
        // create key dictionary for reading p12 file
        let key = kSecImportExportPassphrase as String
        let options : NSDictionary = [key: certPassword]
        
        var items : CFArray?
        let securityError = SecPKCS12Import(p12Data, options, &items)
        
        guard securityError == errSecSuccess else {
            if securityError == errSecAuthFailed {
                print("ERROR: SecPKCS12Import returned errSecAuthFailed. Incorrect password?")
            } else {
                print("Failed to open the certificate file: \(certName).p12")
            }
            return nil
        }
        
        guard let theArray = items, CFArrayGetCount(theArray) > 0 else {
            return nil
        }
        
        let dictionary = (theArray as NSArray).object(at: 0)
        guard let identity = (dictionary as AnyObject).value(forKey: kSecImportItemIdentity as String) else {
            return nil
        }
        let certArray = [identity] as CFArray
        
        return certArray
    }
    
    func simpleSSLSetting() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "penny.4loop.ph", port: 8883)
        mqtt!.username = "penny"
        mqtt!.password = "w3stp4c"
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.enableSSL = true
        mqtt!.publish("test", withString: "hi")
        mqtt!.subscribe("test")
       
    
    }
    
    func selfSignedSSLSetting() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "penny.4loop.ph", port: 8883)
        mqtt!.username = "penny"
        mqtt!.password = "w3stp4c"
        mqtt!.willMessage = CocoaMQTTWill(topic: "test", message: "hllo")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.enableSSL = true
        
        let clientCertArray = getClientCertFromP12File(certName: "client-keycert", certPassword: "MySecretPassword")
        
        var sslSettings: [String: NSObject] = [:]
        sslSettings[kCFStreamSSLCertificates as String] = clientCertArray
        
        mqtt!.sslSettings = sslSettings
    }

    private func createMQTTConnection() {
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: "penny.4loop.ph", port: 8883)
        mqtt.username = "penny"
        mqtt.password = "w3stp4c"
        mqtt.enableSSL = true
        mqtt.delegate = self
        mqtt!.connect()
      
      
    
//
       
    }
}

extension ViewController: CocoaMQTTDelegate {

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print("mqttDidPing")
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print("mqttDidReceivePong")
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("didPublishAck : \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishComplete id: UInt16) {
        print("didPublishComplete: \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopic topic: String) {
        print("didSubscribeTopic: \(topic)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopic topic: String) {
        print("didUnsubscribeTopic: \(topic)")
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("mqttDidDisconnect: \(err?.localizedDescription ?? "")")
    }
    
//    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
//        print("didConnectAck: \(ack)")
//        if ack == .accept {
//            mqtt.subscribe("test", qos: CocoaMQTTQOS.qos1)
//            print("ito na to shit")
//        }
//    }
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("didConnectAck: \(ack)，rawValue: \(ack.rawValue)")
        print("let ther be light:" , light)
        if ack == .accept &&  light == 1{
          
            let message = "Turning Lights On"
            mqtt.publish("test", withString: message,qos: CocoaMQTTQOS.qos1)
            mqtt.subscribe("test", qos: CocoaMQTTQOS.qos1)
            //        let message = CocoaMQTTMessage(topic: "test", string: "hello", qos: .qos1)
            //        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
            //        mqtt = CocoaMQTT(clientID: clientID, host: "penny.4loop.ph", port: 8883)
            //        mqtt!.username = "penny"
            //        mqtt!.password = "w3stp4c"
            //        mqtt!.keepAlive = 60
            //        mqtt!.delegate = self
            //        mqtt!.enableSSL = true
    
        }else if ack == .accept &&  light == 0 {
            let message = "Turning Lights Off"
            mqtt.publish("test", withString: message,qos: CocoaMQTTQOS.qos1)
            mqtt.subscribe("test", qos: CocoaMQTTQOS.qos1)
        }
    }
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didPublishMessage: \(message) and \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        print("didReceiveMessage: \(message) and \(id)")
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceive trust: SecTrust, completionHandler: @escaping (Bool) -> Void) {
        print("didReceive trust")
        mqtt.subscribe("test", qos: CocoaMQTTQOS.qos1)
        mqtt.publish("test", withString: "hi")
    }
}


