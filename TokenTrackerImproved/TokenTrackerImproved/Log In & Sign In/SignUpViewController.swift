//
//  SignUpViewController.swift
//  TokenTracker
//
//  Created by Enoch David Johnson on 6/15/22.
//

import UIKit
import Network
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var logInButton: UIButton!

    // Sign up button clicked
    @IBAction func signUpButtonClicked(_ sender: Any) {
        // Remove any errors presented to user
        Utilities().removeError(label: warningLabel)
        
        // Make sure fullNameTextField isn't empty
        let error1 = validateTextField(tf: fullNameTextField)
        
        // get textfield text
        let fullName = fullNameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (error1 != nil) { // If fullNameTextField is empty, show error
            // This is needed because auth function won't check if full name is empty
            Utilities().showError(label: warningLabel, string: "Missing Field Data")
        } else {
            // Create user in Firebase
            Auth.auth().createUser(withEmail: email!, password: password!) { Result, err in
                
                if let err = err {
                    // Show error to user, if there is an error
                    Utilities().showError(label: self.warningLabel, string: err.localizedDescription)
                } else {
                    // User created successfully
                    let db = Firestore.firestore()
                    
                    // Store user name and email to database
                    db.collection("Users").addDocument(data: ["Full Name":fullName! as Any, "Email": email!, "uid": Result?.user.uid as Any, "Block Chain Address": nil]) { (Error) in
                        
                        if Error != nil {
                            print("Error with storing user data")
                        }
                    }
                    
                    // go to home screen because user signed in
                    Utilities().goToHomeScreen(theView: self.view)
                }
            }
        }
    }
    
    // Log in button clicked
    @IBAction func logInButtonClicked(_ sender: Any) {
        // push user to login View Controller and remove sign up view controller from stack
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "Log In")
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure textfields
        Utilities().bottomLineAndTextColorOfTextField(tf: fullNameTextField, placeHolder: "Full Name", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: emailTextField, placeHolder: "Email", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: passwordTextField, placeHolder: "Password", color: Utilities().darkBlueColor)
        
        // Configure loginButton
        Utilities().boarderOnButton(button: logInButton)
        
    }
    


    func validateTextField (tf: UITextField) -> String? {
        let text = tf.text
        if (text!.isEmpty) {
            return "Missing Field data"
        }
        return nil
    }
    

}
