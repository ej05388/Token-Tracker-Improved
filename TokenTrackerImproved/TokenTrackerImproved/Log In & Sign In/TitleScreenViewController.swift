//
//  TitleScreenViewController.swift
//  TokenTracker
//
//  Created by Enoch David Johnson on 6/13/22.
//

import UIKit

class TitleScreenViewController: UIViewController {

    // Outlet
    @IBOutlet var SignUpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure SignupButton
        SignUpButton.layer.borderWidth = 1
        SignUpButton.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }
    

    



}
