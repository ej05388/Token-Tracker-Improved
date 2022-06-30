//
//  SpeedViewController.swift
//  TokenTrackerImproved
//
//  Created by Enoch David Johnson on 6/22/22.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import Foundation

// MARK: - WelcomeElement
struct OsmMain: Decodable {
    let osm_id: Int?
}

// MARK: - SpeedMain
struct SpeedMainArray: Decodable {
    let type: String?
}


struct SpeedMainReg: Decodable {
    let type: String?
    let extratags: Extratags?
    
    enum CodingKeys: String, CodingKey {
        case type
        case extratags
    }
}
// MARK: - Extratags
struct Extratags: Decodable {
    let maxspeed: String?
    
    enum CodingKeys: String, CodingKey {
        case maxspeed
    }
}

class SpeedViewController: UIViewController {
    
    // Outlets
    @IBOutlet var currentSpeed: UILabel!
    @IBOutlet var speedLimitLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    

    @IBAction func refreshAddress(_ sender: Any) {
        getAddress()
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        print("Go")
        handleSignOut()
    }
    
    // Variables
    let locationManager = CLLocationManager()
    var theLocation: CLLocation = CLLocation(latitude: 1000, longitude: 1000)
    var previousLocation: CLLocation = CLLocation(latitude: 0, longitude: 0)
    var newStreet = ""
    var oldStreet = "Avenue"
    var city = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CLLocationManager().delegate = self
//        CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
//        CLLocationManager().requestWhenInUseAuthorization()
//        CLLocationManager().startUpdatingLocation()
        checkLocationServices()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.getAddress()
        }
    }

    // MARK: Sign Out
    @objc func handleSignOut() {
        
        // Create Alert
        var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to sign out?", preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "Sign Out", style: .default, handler: { (action) -> Void in
            self.signOut()
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }

        //Add OK and Cancel button to an Alert object
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            Utilities().goToTitleScreen(theView: self.view)
        } catch let error {
            print("Failed to sign out with error: ", error)
        }
    }
    
    // MARK: Location Services
    func getAddress() {
        
        guard theLocation.distance(from: previousLocation) > 50 else {return}
        previousLocation = theLocation
        
        CLGeocoder().reverseGeocodeLocation(theLocation) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            
            self.newStreet = placemark.thoroughfare ?? ""
            self.city = placemark.locality ?? ""
            
            DispatchQueue.main.async {
                self.addressLabel.text = "\(self.newStreet) \(self.city)"
                if (self.newStreet != self.oldStreet) {
                    self.getOsm_id()
                    self.oldStreet = self.newStreet
                }
            }


            
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Create Alert
            var dialogMessage = UIAlertController(title: "Confirm", message: "Your location services is off. Go to Settings > Privacy & Security > Location Services and turn it on", preferredStyle: .alert)

            // Create Cancel button with action handlder
            let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                
            }

            //Add OK and Cancel button to an Alert object
            dialogMessage.addAction(ok)
            
            // Present alert message to user
            self.present(dialogMessage, animated: true, completion: nil)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            trackLocation()
            getAddress()
            break
        case .denied:
            // Show alert to turn on permission for app
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            trackLocation()
            break

        }
    }
    
    func trackLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Parse
    func getOsm_id() {
        // MARK: - Parse Things
        let streetUrl = charReplacer(string: newStreet)
        let cityUrl = charReplacer(string: city)
        let url = "https://nominatim.openstreetmap.org/search.php?q=" + streetUrl + "+" + cityUrl + "&countrycodes=us&format=jsonv2"
        
        let urlObj = URL(string: url)

        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            do {
                let osmMainData = try! JSONDecoder().decode([OsmMain].self, from: data!)

                let num = "\(osmMainData[0].osm_id!)"

                DispatchQueue.main.async {

                    self.getSpeedLimit(num: num)
                    
                }
            }
        }.resume()
    }
    
    func getSpeedLimit(num: String) {
        let secondUrl = "https://nominatim.openstreetmap.org/details.php?osmtype=W&osmid=" + num + "&class=highway&addressdetails=1&hierarchy=0&group_hierarchy=1&format=json"
        print(secondUrl)
        let secondUrlObj = URL(string: secondUrl)
        
        URLSession.shared.dataTask(with: secondUrlObj!) { [self](data, response, error) in
                do {
                    //let osmMainData = try! JSONDecoder().decode(SpeedMain.self, from: data!)
                    
                    let speedMainData: SpeedMainReg = try JSONDecoder().decode(SpeedMainReg.self, from: data!)
                    // Loops for each sensor
                    let num = speedMainData.extratags?.maxspeed
                    let type = speedMainData.type
                    
                    DispatchQueue.main.async { [self] in
                        checkSpeedLimitNil(num: num!, type: type!)
                    }
                    
                } catch {
                    
                    self.speedMainArrayParse(urlObj: secondUrlObj!)
                }
            

        }.resume()
    }
    
    func speedMainArrayParse(urlObj: URL) {
        URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
                do {
                    //let osmMainData = try! JSONDecoder().decode(SpeedMain.self, from: data!)
                    
                    let speedMainData: SpeedMainArray = try JSONDecoder().decode(SpeedMainArray.self, from: data!)
                    // Loops for each sensor
                    let type = speedMainData.type


                    DispatchQueue.main.async {
                        self.checkSpeedLimitNil(num: nil, type: type!)
                    }
                    
                } catch {
                }
            

        }.resume()
    }
    
    func checkSpeedLimitNil(num: String?, type: String) {
        var limit = -1
        
        if num == nil {
            print("No speed limit provided")
            print(type)
            if type == "motorway" {
                limit = 75
            } else if type == "trunk" {
                limit = 45
            } else if type == "primary" {
                limit = 55
            } else if type == "secondary" {
                limit = 45
            } else if type == "tertiary" {
                limit = 40
            } else if type == "unclassified" {
                limit = 35
            } else if type == "residential" {
                limit = 25
            } else {
                limit = -1
            }
            
            speedLimitLabel.text = "\(limit)"
            
        } else {
            print("speed limit provided")
            speedLimitLabel.text = num
        }
    }
    
    func charReplacer(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "%20")
    }
}

extension SpeedViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        theLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        //theLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let speed = locations[0]
        currentSpeed.text = "\(speed.speed)"
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

