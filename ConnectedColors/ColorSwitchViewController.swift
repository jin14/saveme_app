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
        NSLog("Tapped")
        self.toggle()
//        colorService.send(colorName: "red")
       let currentDate = NSDate()
        NSLog("%@", currentDate);
        colorService.send(phoneNumber: 32, Lat: "123", Long: "321", timeStamp: "18Jan2017")
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
                NSLog("%@", self.toggleButton.titleLabel?.text ?? "default")
            }
            else {
                self.toggleButton.setTitle("On",for: .normal)
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
//        OperationQueue.main.addOperation {
//            
//        }
    }

}
