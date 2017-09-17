import UIKit

class ColorSwitchViewController: UIViewController {

    @IBOutlet weak var connectionsLabel: UILabel!
    @IBOutlet weak var toggleButton : UIButton!
    
    let colorService = ColorServiceManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        colorService.delegate = self
    }

    @IBAction func redTapped() {
        var Lat : String = ","
        var Long : String = ","
        NSLog("Tapped")
        self.toggle()
//        colorService.send(colorName: "red")
       let currentDate = NSDate()
        NSLog("%@", currentDate);
//        let locMgr: INTULocationManager = INTULocationManager.sharedInstance()
//        locMgr.requestLocation(withDesiredAccuracy: INTULocationAccuracy.block,
//                               timeout: 10.0,
//                               delayUntilAuthorized: true,
//                               block: {(currentLocation: CLLocation?, achievedAccuracy: INTULocationAccuracy, status: INTULocationStatus) -> Void in
//                                if status == INTULocationStatus.success {
//                                    Lat = "\(String(describing: currentLocation?.coordinate.latitude))"
//                                    Long = "\(String(describing: currentLocation?.coordinate.longitude))"
//                                }
//                                else {
//                                    Lat = "Error getting location"
//                                    Long = "Error getting location"
//                                }
//        })
        
//        colorService.send(phoneNumber: 32, Lat: Lat, Long: Long, timeStamp: "1505653281")
    }
//
//    @IBAction func yellowTapped() {
//        self.change(color: .yellow)
//        colorService.send(colorName: "yellow")
//    }
//
    func change(color : UIColor) {
        UIView.animate(withDuration: 0.2) {
            self.view.backgroundColor = color
        }
    }
    
    func toggle() {
        UIView.animate(withDuration: 0) {
            if (self.toggleButton.titleLabel?.text == "On") {
                self.toggleButton.setTitle("Off",for: .normal)
                self.colorService.switchServiceOn();
            }
            else {
                self.toggleButton.setTitle("On",for: .normal)
                self.colorService.switchServiceOff();
            }
        }
    }
}

extension ColorSwitchViewController : ColorServiceManagerDelegate {

    func connectedDevicesChanged(manager: ColorServiceManager, connectedDevices: [String]) {
        OperationQueue.main.addOperation {
            self.connectionsLabel.text = "Connections: \(connectedDevices)"
        }
    }

//    func colorChanged(manager: ColorServiceManager, colorString: String) {
//        OperationQueue.main.addOperation {
//            switch colorString {
//            case "red":
//                self.change(color: .red)
//            case "yellow":
//                self.change(color: .yellow)
//            default:
//                NSLog("%@", "Unknown color value received: \(colorString)")
//            }
//        }
//    }
    
    func propagateMessage(manager: ColorServiceManager, messageString: String) {
        OperationQueue.main.addOperation {
            
        }
    }

}
