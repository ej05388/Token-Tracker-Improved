//
//  Utilities.swift
//  TokenTracker
//
//  Created by Enoch David Johnson on 6/18/22.
//

import UIKit

class Utilities: UIViewController {

    let darkBlueColor = UIColor(red: 0/255, green: 19/255, blue: 51/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func boarderOnButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func boarderOnView(view: UIView, borderWidth: Int, borderColor: UIColor) {
        view.layer.borderWidth = CGFloat(borderWidth)
        view.layer.borderColor = borderColor.cgColor
        
    }
    
    func bottomLineAndTextColorOfTextField(tf: UITextField, placeHolder: String, color: UIColor) {
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: tf.frame.height - 10, width: tf.frame.width, height: 2)
        
        bottomLine.backgroundColor = color.cgColor
        
        tf.borderStyle = .none
        
        tf.layer.addSublayer(bottomLine)
        
        tf.attributedPlaceholder = NSAttributedString(
            string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    func removeError (label: UILabel) {
        //label.font = label.font.withSize(1)
        label.textColor = UIColor.white
    }

    func showError(label: UILabel, string: String) {
        label.textColor = UIColor.red
        label.text = string
    }
    
    func goToHomeScreen(theView: UIView) {
        let storyBoard = UIStoryboard(name: "Speed", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "speedVC")
        theView.window?.rootViewController = vc
        theView.window?.makeKeyAndVisible()
        
//        let story = UIStoryboard(name: "Home", bundle:nil)
//        let vc = story.instantiateViewController(withIdentifier: "homeVC") as! NewViewController
//        UIApplication.shared.windows.first?.rootViewController = vc
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
        

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
