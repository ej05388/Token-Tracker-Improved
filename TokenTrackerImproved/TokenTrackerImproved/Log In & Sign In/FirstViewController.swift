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
        
        authenticateUserAndConfigureView()
        
        // Do any additional setup after loading the view.
    }
    
    func authenticateUserAndConfigureView() {
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                Utilities().goToHomeScreen(theView: self.view)
            }
        } else {
            DispatchQueue.main.async {
                Utilities().goToTitleScreen(theView: self.view)
            }
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
