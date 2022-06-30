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
    // Text Fields
    @IBOutlet var fullNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // Warning Label
    
    @IBOutlet var warningLabel: UILabel!
    
    // Buttons
    @IBOutlet var logInButton: UIButton!
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        Utilities().removeError(label: warningLabel)
        
        let error1 = validateTextField(tf: fullNameTextField)
        
        let fullName = fullNameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if (error1 != nil) { // Needed because auth function won't check for name
            Utilities().showError(label: warningLabel, string: "Missing Field Data")
        } else {
            Auth.auth().createUser(withEmail: email!, password: password!) { Result, err in
                
                if let err = err {
                    // There was an error
                    Utilities().showError(label: self.warningLabel, string: err.localizedDescription)
                } else {
                    // User created successfully
                    let db = Firestore.firestore()
                    
                    db.collection("Users").addDocument(data: ["Full Name":fullName! as Any, "Email": email!, "uid": Result?.user.uid as Any, "Block Chain Address": nil]) { (Error) in
                        
                        if Error != nil {
                            print("Error with storing user data")
                        }
                    }
                    
                    // TODO: go to home screen
                    Utilities().goToHomeScreen(theView: self.view)
                }
            }
        }
        
//        if (error1 != nil || error2 != nil || error3 != nil ) {
//            showError(label: warningLabel, string: "Missing Field data")
//        } else if (error4 != nil) {
//            showError(label: warningLabel, string: error4!)
//        } else if (error5 != nil){
//            showError(label: warningLabel, string: error5!)
//        }
        


            

    }
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "Log In")
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities().bottomLineAndTextColorOfTextField(tf: fullNameTextField, placeHolder: "Full Name", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: emailTextField, placeHolder: "Email", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: passwordTextField, placeHolder: "Password", color: Utilities().darkBlueColor)
        
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
