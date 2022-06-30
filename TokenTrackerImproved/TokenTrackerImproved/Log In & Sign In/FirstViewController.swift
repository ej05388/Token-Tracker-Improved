//
//  FirstViewController.swift
//  TokenTrackerImproved
//
//  Created by Enoch David Johnson on 6/28/22.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Checks if user is logged in
        authenticateUserAndConfigureView()

    }
    
    func authenticateUserAndConfigureView() {
        
        if Auth.auth().currentUser != nil { // If user is logged in, go to Home screen
            DispatchQueue.main.async {
                Utilities().goToHomeScreen(theView: self.view)
            }
        } else { // if user is not logged in, go to Title Screen
            DispatchQueue.main.async {
                Utilities().goToTitleScreen(theView: self.view)
            }
            
        }
    }

}
