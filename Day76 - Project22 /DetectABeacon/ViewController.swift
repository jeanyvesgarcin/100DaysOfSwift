//
//  ViewController.swift
//  Day76 - Project22
//
//  Created by Jean-Yves Garcin on 26/06/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var beaconIdentifier: UILabel!
    @IBOutlet var distanceReading: UILabel!
    @IBOutlet var circleView: UIView!
    
    var locationManager: CLLocationManager?
    var beaconDetected = false
    var currentBeaconRange: CLBeaconRegion!
    
    struct BeaconStruct {
        var identifier: String
        var uuid : UUID
    }
    
    var arr: [BeaconStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        view.backgroundColor = .gray
        
        circleView.layer.cornerRadius = 130
        
        let testUuid = BeaconStruct(identifier: "Apple Test", uuid:  UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!)
        
        let myUUID1 = BeaconStruct(identifier: "Beacon Jean-Yves", uuid: UUID(uuidString: "1722fcfa-c052-12e9-9cb2-2a2ae2dbcce2")!)
        
        
        arr = [testUuid, myUUID1]
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    selectBeacon()
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if (!beaconDetected) {
                beaconDetected = true
                let ac = UIAlertController(title: "Beacon Status", message: "Beacon detected", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
            update(distance: beacon.proximity, uuid: beacon.proximityUUID.uuidString)
        } else {
            update(distance: .unknown)
        }
    }
    
    func selectBeacon() {
        let ac = UIAlertController(title: "Beacons", message: "Select a beacon", preferredStyle: .actionSheet)
        for beacon in arr {
            ac.addAction(UIAlertAction(title: beacon.identifier, style: .default, handler: startScanning))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func startScanning(action: UIAlertAction) {

        let beacon = self.arr.filter{ $0.identifier == action.title }.first
        if let beacon = beacon {
            currentBeaconRange = CLBeaconRegion(proximityUUID: beacon.uuid, major: 123, minor: 456, identifier: beacon.identifier)
            
            locationManager?.startMonitoring(for: currentBeaconRange)
            locationManager?.startRangingBeacons(in: currentBeaconRange)
        }
    }
    
    func update(distance: CLProximity, uuid: String? = nil) {
        UIView.animate(withDuration: 1) {
            
            if uuid != nil {
                let identifier = self.arr.filter{ $0.uuid.uuidString == uuid }.first?.identifier
                self.beaconIdentifier.text = identifier
            }
            
            var transformValue: CGFloat
            var newBackgroundColor: UIColor
            
            switch distance {
            case .far:
                newBackgroundColor = .blue
                transformValue = 0.25
                self.distanceReading.text = "FAR"
                
            case .near:
                newBackgroundColor = .orange
                transformValue = 0.5
                self.distanceReading.text = "NEAR"

            case .immediate:
                newBackgroundColor = .red
                transformValue = 1.0
                self.distanceReading.text = "RIGHT HERE"
                
            default:
                newBackgroundColor = UIColor.gray
                transformValue = 0.1
                self.distanceReading.text = "UNKNOWN"
                
            }
            
            self.circleView.backgroundColor = newBackgroundColor
            self.circleView.transform = CGAffineTransform(scaleX: transformValue, y: transformValue)
        }
    }
    
    @IBAction func reSelectTapped(_ sender: Any) {
        if (currentBeaconRange != nil) {
            locationManager?.stopMonitoring(for: currentBeaconRange)
            locationManager?.stopRangingBeacons(in: currentBeaconRange)
        }
        
        selectBeacon()
    }
    
}

