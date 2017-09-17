//
//  ColorServiceManager.swift
//  ConnectedColors
//
//  Created by Ralf Ebert on 10/02/2017.
//  Copyright © 2017 Example. All rights reserved.
//

import Foundation
import MultipeerConnectivity
import Alamofire

protocol ColorServiceManagerDelegate {

    func connectedDevicesChanged(manager : ColorServiceManager, connectedDevices: [String])
//    func colorChanged(manager : ColorServiceManager, colorString: String)
    func propagateMessage(manager : ColorServiceManager, messageString: String)

}

class ColorServiceManager : NSObject {
    
    var timer : Timer!;
    
    // Service type must be a unique string, at most 15 characters long
    // and can contain only ASCII lowercase letters, numbers and hyphens.
    private let ColorServiceType = "example-color"

    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)

    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser

    var delegate : ColorServiceManagerDelegate?

    lazy var session : MCSession = {
//        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .required)
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
        session.delegate = self
        return session
    }()

    override init() {
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: ColorServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: ColorServiceType)

        super.init()
        
        self.serviceAdvertiser.delegate = self
//        self.serviceAdvertiser.startAdvertisingPeer()

        self.serviceBrowser.delegate = self
//        self.serviceBrowser.startBrowsingForPeers()
    }

//    func send(colorName : String) {
//        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
//
//        if session.connectedPeers.count > 0 {
//            do {
//                try self.session.send(colorName.data(using: .utf8)!, toPeers: session.connectedPeers, with: .reliable)
//            }
//            catch let error {
//                NSLog("%@", "Error for sending: \(error)")
//            }
//        }
//
//    }
    
    func greet(person: String) -> String {
        let greeting = "Hello, " + person + "!"
        return greeting
    }
    
    func send(phoneNumber : Int, Lat: String , Long : String, timeStamp : String) {
//        NSLog("%@", "sendColor: \(colorName) to \(session.connectedPeers.count) peers")
        
        if session.connectedPeers.count > 0 {
            do {
                let seperator: String = ","
                let messageData = NSMutableData()
                let score: String = (phoneNumber as NSNumber).stringValue
//                let phoneNumberdata = NSData(bytes: &score, length: MemoryLayout<Int>.size)
                
//                let httpString : String = "http://104.236.153.222:8000/incoming-message/?text=" + score + "," + "+37.78037652" + "," + "-122.38641105" + "," + "1505653281";
//                NSLog("%@", httpString);
                
                
                let httpString : String = "http://104.236.153.222:8000/incoming-message/?text=" + score + "," + Lat + "," + Long + "," + "1505653281";
                NSLog("%@", httpString);
                
                messageData.append(score.data(using: .utf8)!)
                messageData.append(seperator.data(using: .utf8)!)
                
                messageData.append(Lat.data(using: .utf8)!)
                messageData.append(seperator.data(using: .utf8)!)
                
                messageData.append(Long.data(using: .utf8)!)
                messageData.append(seperator.data(using: .utf8)!)
                
//                var tempDate: NSDate = timeStamp;
//                let dateData = Data(bytes: &tempDate, count: MemoryLayout<TimeInterval>.size)
//                messageData.append(dateData as Data)
                messageData.append(timeStamp.data(using: .utf8)!)
                
                try self.session.send(messageData as Data, toPeers: session.connectedPeers, with: .reliable)
//                Alamofire.request(httpString)
                
                Alamofire.request(httpString).responseJSON { response in
                    print("Request: \(String(describing: response.request))")   // original url request
                    print("Response: \(String(describing: response.response))") // http url response
                    print("Result: \(response.result)")                         // response serialization result
                    
                    if let json = response.result.value {
                        print("JSON: \(json)") // serialized json response
                    }
                    
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Data: \(utf8Text)") // original server data as UTF8 string
                    }
                }
                
//                // Set the URL the request is being made to.
//                let request = URLRequest(url: NSURL(string: httpString)! as URL)
//                do {
//                    // Perform the request
//                    var response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
//                    NSLog("Response: %@", response!)
//                    let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
//                    
//                    // Convert the data to JSON
//                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
//                    
//                    if let json = jsonSerialized, let url = json["url"], let explanation = json["explanation"] {
//                        print(url)
//                        print(explanation)
//                    }
//                }
            }
            catch let error {
                NSLog("%@", "Error for sending: \(error)")
            }
        }
    }
    
    func alamoFire(dataString: String) {
        Alamofire.request(dataString).responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }

    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }

    func switchServiceOn() {
        self.serviceBrowser.startBrowsingForPeers()
        self.serviceAdvertiser.startAdvertisingPeer()
        timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(self.prepareSend), userInfo: nil, repeats: true)
    }
    
    func switchServiceOff() {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        timer.invalidate();
    }
    
    func getSession() -> MCSession {
        return session;
    }
    
    func prepareSend() {
//        if (status == INTULocationStatusSuccess) {
//            // achievedAccuracy is at least the desired accuracy (potentially better)
//            strongSelf.statusLabel.text = [NSString stringWithFormat:@"Location request successful! Current Location:\n%@", currentLocation];
//        }
//        else if (status == INTULocationStatusTimedOut) {
//            // You may wish to inspect achievedAccuracy here to see if it is acceptable, if you plan to use currentLocation
//            strongSelf.statusLabel.text = [NSString stringWithFormat:@"Location request timed out. Current Location:\n%@", currentLocation];
//        }
//        else {
//            // An error occurred
//            strongSelf.statusLabel.text = [strongSelf getLocationErrorDescription:status];
//        }
        let phoneNumber : Int = 6282331051
        var Lat : String = ""
        var Long : String = ""
        let timeStamp : String = "1505653281"
        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
                               timeout: 15.0,
                               delayUntilAuthorized: true,
                               block: {(currentLocation: CLLocation!, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
                                if status == INTULocationStatus.success {
                                    NSLog("Enters if")
                                    Lat = "\(String(describing: currentLocation!.coordinate.latitude))"
                                    Long = "\(String(describing: currentLocation!.coordinate.longitude))"
                                    self.send(phoneNumber: phoneNumber, Lat: Lat, Long: Long, timeStamp: timeStamp)
                                }
                                else if status == INTULocationStatus.timedOut {
                                    NSLog("Enters else if")
                                    Lat = "\(String(describing: currentLocation!.coordinate.latitude))"
                                    Long = "\(String(describing: currentLocation!.coordinate.longitude))"
                                    self.send(phoneNumber: phoneNumber, Lat: Lat, Long: Long, timeStamp: timeStamp)
                                }
                                else {
                                    NSLog("Enters else")
                                    Lat = "Error getting location"
                                    Long = "Error getting location"
                                    self.send(phoneNumber: phoneNumber, Lat: Lat, Long: Long, timeStamp: timeStamp)
                                }
        })
    }
}

extension ColorServiceManager : MCNearbyServiceAdvertiserDelegate {

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }

}

extension ColorServiceManager : MCNearbyServiceBrowserDelegate {

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        NSLog("%@", "invitePeer: \(peerID)")
        browser.invitePeer(peerID, to: self.session, withContext: nil, timeout: 10)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
    }
    
}

extension ColorServiceManager : MCSessionDelegate {

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        NSLog("%@", "peer \(peerID) didChangeState: \(state)")
        self.delegate?.connectedDevicesChanged(manager: self, connectedDevices:
            session.connectedPeers.map{$0.displayName})
    }

//    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
//        NSLog("%@", "didReceiveData: \(data)")
//        let str = String(data: data, encoding: .utf8)!
//        self.delegate?.colorChanged(manager: self, colorString: str)
//    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveData: \(data)")
        let str = String(data: data, encoding: .utf8)!
        NSLog("The string is: %@", str)
        self.delegate?.propagateMessage(manager: self, messageString: str)
    }

    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        NSLog("%@", "didFinishReceivingResourceWithName")
    }

}
