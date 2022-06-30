//
//  LogiinViewController.swift
//  TokenTracker
//
//  Created by Enoch David Johnson on 6/14/22.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class LoginViewController: UIViewController {
    
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    // Connect buttons to view controller
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    // If log in button is clicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        Utilities().removeError(label: errorLabel)
        
        let email = emailTextField.text
        let password = passwordTextField.text!
        

        Auth.auth().signIn(withEmail: email!, password: password) { result, authError in

            if authError?.localizedDescription == "The email address is badly formatted." {
                Utilities().showError(label: self.errorLabel, string: "Email is incorrectly formatted")
            } else if authError?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                Utilities().showError(label: self.errorLabel, string: "User doesn't exist")
            } else if authError?.localizedDescription == "The password is invalid or the user does not have a password." {
                Utilities().showError(label: self.errorLabel, string: "Password is incorrect")
            } else if authError != nil {
                print(authError?.localizedDescription)
                Utilities().showError(label: self.errorLabel, string: authError!.localizedDescription)
            } else {
                Utilities().goToHomeScreen(theView: self.view)
                
            }
        }
        
    }
    

    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "Sign Up") 
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    // Connect text fields to view controller
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // Created a variable for this specific color because this color is used often in code
    //let darkBlueColor = UIColor(red: 0/255, green: 19/255, blue: 51/255, alpha: 1)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        // Called this function for the sign up button
        Utilities().boarderOnButton(button: signUpButton)
        
        // Called this function for email and password textfields
        Utilities().bottomLineAndTextColorOfTextField(tf: emailTextField, placeHolder: "Email", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: passwordTextField, placeHolder: "Password", color: Utilities().darkBlueColor)
    
        
    
    }

}
