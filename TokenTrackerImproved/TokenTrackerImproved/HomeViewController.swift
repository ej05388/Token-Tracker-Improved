//
//  HomeViewController.swift
//  TokenTrackerImproved
//
//  Created by Enoch David Johnson on 6/22/22.
//


import UIKit
import CoreLocation
import MapKit
import Firebase
import Foundation

// MARK: Structures of API's JSON
// This is so we can use this structure to parse the JSON

// MARK: API to get specific road
// Struct of API to get the OSM ID for that specific road
struct OsmMain: Decodable {
    let osm_id: Int? // osm_id is a unique id for a street
}

// MARK: API to get speed limit
// Struct for the top layer of the JOSN if JSON is an array
struct SpeedMainArray: Decodable {
    let type: String?
}

// Struct for the top layer of the JOSN if JSON is not an array
struct SpeedMainReg: Decodable {
    let type: String?
    let extratags: Extratags?
    
    enum CodingKeys: String, CodingKey {
        case type
        case extratags
    }
}

// struct to access the speed limit
struct Extratags: Decodable {
    let maxspeed: String?
    
    enum CodingKeys: String, CodingKey {
        case maxspeed
    }
}

class HomeViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var currentSpeed: UILabel!
    @IBOutlet var speedLimitLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    

    @IBAction func refreshAddress(_ sender: Any) {
        getAddress()
    }
    
    // if user clicks log out icon, this function will run
    @IBAction func logOutClicked(_ sender: Any) {
        handleSignOut()
    }
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var theLocation: CLLocation = CLLocation(latitude: 1000, longitude: 1000)
    var newStreet = ""
    var oldStreet = "Nil"
    var city = ""

    // MARK: "Main Method"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if user has location services turned on for their iPhone, and if not, to prompt them
        checkLocationServices()
        
        // Every 1 min to check if user has changed their location
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.getAddress()
        }
    }

    // MARK: Asks user if they want to sign out
    @objc func handleSignOut() {
        
        // Create Alert
        var dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you want to sign out?", preferredStyle: .alert)

        // Create Sign out button with action handler
        let ok = UIAlertAction(title: "Sign Out", style: .default, handler: { (action) -> Void in
            // If user clicks they want to sign out, the sign out func will run
            self.signOut()
        })

        // Create Cancel button with action handlder
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        }

        //Add Sign out and Cancel button to an Alert object
        dialogMessage.addAction(cancel)
        dialogMessage.addAction(ok)
        
        // Present alert message to user
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    //MARK: Sign out func
    func signOut() {
        do {
            // Sign out user and presents the TitleViewController
            try Auth.auth().signOut()
            
            Utilities().goToTitleScreen(theView: self.view) // func can be found in the Utilities swift file
        } catch let error {
            print("Failed to sign out with error: ", error)
        }
    }
    
    // Turn coordinates into address
    func getAddress() {

        CLGeocoder().reverseGeocodeLocation(theLocation) { [weak self] (placemarks, error) in
            guard let self = self else {return}
            
            if let _ = error {
                return
            }
            
            guard let placemark = placemarks?.first else {
                return
            }
            
            // gets street and city name
            self.newStreet = placemark.thoroughfare ?? ""
            self.city = placemark.locality ?? ""
            
            DispatchQueue.main.async {
                // Display street and city to user
                self.addressLabel.text = "\(self.newStreet) \(self.city)"
                
                // if the user is in a new street, the OSM_id is retrieved from API
                if (self.newStreet != self.oldStreet) {
                    self.getOsm_id()
                    self.oldStreet = self.newStreet
                }
            }
        }
    }
    
    // Checks if user has location services on for their iPhone
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Set up location manager
            setupLocationManager()
            // Check if the app has permission to access location services
            checkLocationAuthorization()
        } else {
            // Tell them to turn on location services for their iPhone
            var dialogMessage = UIAlertController(title: "Confirm", message: "Your location services is off. Go to Settings > Privacy & Security > Location Services and turn it on", preferredStyle: .alert)

            // Create ok button
            let ok = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
                
            }

            //Add OK button to an Alert object
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
            //TODO: Show alert to turn on location service permission for app
            break
        case .notDetermined:
            // Request to user to access their location services
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            trackLocation()
            getAddress()
            break

        }
    }
    
    func trackLocation() {
        locationManager.startUpdatingLocation()
    }
    
    // MARK: Get osm_id for their street
    func getOsm_id() {
        // create api link using their street and city
        let streetUrl = charReplacer(string: newStreet)
        let cityUrl = charReplacer(string: city)
        let url = "https://nominatim.openstreetmap.org/search.php?q=" + streetUrl + "+" + cityUrl + "&countrycodes=us&format=jsonv2"
        
        let urlObj = URL(string: url)
        
        // Parse JSON to get osm_id
        URLSession.shared.dataTask(with: urlObj!) {(data, response, error) in
            do {
                let osmMainData = try! JSONDecoder().decode([OsmMain].self, from: data!)

                let num = "\(osmMainData[0].osm_id!)"

                DispatchQueue.main.async {

                    // Once the app gets the osm_id, run this func to get speed limit for the street
                    self.getSpeedLimit(osm_id: num)
                }
            }
        }.resume()
    }
    
    // MARK: From the osm_id, get the speed limit for their street
    func getSpeedLimit(osm_id: String) {
        // create api link using osm_id
        let secondUrl = "https://nominatim.openstreetmap.org/details.php?osmtype=W&osmid=" + osm_id + "&class=highway&addressdetails=1&hierarchy=0&group_hierarchy=1&format=json"
        
        let secondUrlObj = URL(string: secondUrl)
        
        // Parse JSON to get speed limit
        URLSession.shared.dataTask(with: secondUrlObj!) { [self](data, response, error) in
                do {
                    
                    
                    let speedMainData: SpeedMainReg = try JSONDecoder().decode(SpeedMainReg.self, from: data!)
                    
                    // get speed limit and the type of road it is
                    let num = speedMainData.extratags?.maxspeed
                    let type = speedMainData.type
                    
                    DispatchQueue.main.async { [self] in
                        // func to check if any values are nil
                        checkSpeedLimitNil(num: num!, type: type!)
                    }
                    
                } catch {
                    
                    // if there is any error, that means the JSON is in an array form. So run this func to parse the JSON as an array
                    self.speedMainArrayParse(urlObj: secondUrlObj!)
                }

        }.resume()
    }
    
    // MARK: From the osm_id, get the speed limit for their street if JSON is an array
    func speedMainArrayParse(urlObj: URL) {
        
        // Parse JSON to get speed limit
        URLSession.shared.dataTask(with: urlObj) {(data, response, error) in
                do {
                    let speedMainData: SpeedMainArray = try JSONDecoder().decode(SpeedMainArray.self, from: data!)
                    
                    // Since JSON is array, it means there is no speed limit provided by the API so just the road type is taken
                    let type = speedMainData.type


                    DispatchQueue.main.async {
                        // func to check if any values are nil
                        self.checkSpeedLimitNil(num: nil, type: type!)
                    }
                    
                } catch {
                }
            
        }.resume()
    }
    
    //MARK: Check if speed limit is provided. if not, using the road type, we can estimate the speed limit
    func checkSpeedLimitNil(num: String?, type: String) {
        var limit = -1
        
        // No speed limit is provided
        if num == nil {
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
            // Speed limit is provided
            speedLimitLabel.text = num
            print(num)
        }
    }
    
    // Replaces spaces with "%20" because urls don't have spaces
    func charReplacer(string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "%20")
    }
}


extension HomeViewController: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // get user coordinates
        guard let location = locations.last else { return }
        theLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
 
        // get user speed
        let speed = locations[0]
        let speedInt = Int(speed.speed)
        currentSpeed.text = "\(speedInt) mph"
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

