//
//  PasswordViewController.swift
//  TokenTracker
//
//  Created by Enoch David Johnson on 6/18/22.
//

import UIKit
import Firebase
import Network

class PasswordViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var backButtonItem: UIBarButtonItem!
    
    // send reset password email when button clicked
    @IBAction func resetEmailButton(_ sender: Any) {
        let auth = Auth.auth()
        
        auth.sendPasswordReset(withEmail: emailTextField.text!) { error in
            if let error = error { // If there is error
                var presentedError = error.localizedDescription
                if (error.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted.") {// if email is not in database, show user error
                    presentedError = "User doesn't exist"
                } else if (error.localizedDescription == "The email address is badly formatted.") { // if email is badly formatted, show user error
                    presentedError = "The email address is incorrectly formatted"
                }
                
                // Show user error
                Utilities().showError(label: self.errorLabel, string: presentedError)
                return
            }
            
            //MARK: Tell user email has been sent
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Great!", message: "Email has been sent", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)

            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure top left back button
        let backButton = UIBarButtonItem()
        backButton.title = ""
        backButton.tintColor = Utilities().darkBlueColor
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // Customize text field
        Utilities().bottomLineAndTextColorOfTextField(tf: emailTextField, placeHolder: "Email", color: Utilities().darkBlueColor)
        
        // Do any additional setup after loading the view.
    }

}
