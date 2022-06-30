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
    // Outlets
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var logInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    // Connect text fields to view controller
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    // If log in button is clicked
    @IBAction func loginButtonClicked(_ sender: Any) {
        // remove any errors from UI
        Utilities().removeError(label: errorLabel)
        
        // get the textfield values
        let email = emailTextField.text
        let password = passwordTextField.text!
        
        // Try to sign in user
        Auth.auth().signIn(withEmail: email!, password: password) { result, authError in
            
            // if email is not written properly, show user the error
            if authError?.localizedDescription == "The email address is badly formatted." {
                Utilities().showError(label: self.errorLabel, string: "Email is incorrectly formatted")
            } else if authError?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." { // // if user email is not in database, show user the error
                Utilities().showError(label: self.errorLabel, string: "User doesn't exist")
            } else if authError?.localizedDescription == "The password is invalid or the user does not have a password." { // if password is not correct, show user the error
                Utilities().showError(label: self.errorLabel, string: "Password is incorrect")
            } else if authError != nil { // if any other error occurs, show user the error
                print(authError?.localizedDescription)
                Utilities().showError(label: self.errorLabel, string: authError!.localizedDescription)
            } else { // if there is no error, go to Home screen
                Utilities().goToHomeScreen(theView: self.view)
            }
        }
    }
    
    //MARK: Sign up button clicked
    @IBAction func signUpButtonClicked(_ sender: Any) {
        // push user to Sign Up View Controller and remove login view controller from stack
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVc = storyboard.instantiateViewController(withIdentifier: "Sign Up") 
        var vcArray = self.navigationController?.viewControllers
        vcArray!.removeLast()
        vcArray!.append(newVc)
        self.navigationController?.setViewControllers(vcArray!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        forgotPasswordButton.titleLabel?.font = .systemFont(ofSize: 15)
        
        // Added boarder to the sign up button
        Utilities().boarderOnButton(button: signUpButton)
        
        // Customize email and password textfields
        Utilities().bottomLineAndTextColorOfTextField(tf: emailTextField, placeHolder: "Email", color: Utilities().darkBlueColor)
        Utilities().bottomLineAndTextColorOfTextField(tf: passwordTextField, placeHolder: "Password", color: Utilities().darkBlueColor)
    
    }

}
