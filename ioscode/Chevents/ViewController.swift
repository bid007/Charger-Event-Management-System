//
//  ViewController.swift
//  Chevents
//
//  Created by Bid Sharma on 9/3/16.
//  Copyright © 2016 Bid Sharma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SwiftyJSON

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBAction func signInButton(_ sender: AnyObject) {
        let username = usernameTextField.text
        let password = passwordTextField.text
        let firAuth = FIRAuth.auth()
        if (username!.isEmpty || password!.isEmpty){
            self.showAlert(mainTitle: "Enter required fields", message: "Missing username or password.", actionTitle: "Ok")
        }else{
            firAuth?.signIn(withEmail: username!, password: password!, completion: {
                user, error in
                
                if let error = error{
                    //parse the eror message
                    //display the required error message
                    print(error)
                    self.showAlert(mainTitle: "Error!", message: error.localizedDescription, actionTitle: "Retry")
                }
                
                if user != nil{
                    //send signed in user information to server to get contents
                    let storyboard : UIStoryboard = UIStoryboard(name: "UserTable", bundle: nil)
                    let VC : UserTableVC = storyboard.instantiateViewController(withIdentifier: "usertable") as! UserTableVC
                    self.navigationController?.pushViewController(VC, animated: true)
                    
                }
            })
        }
    }
    
    @IBAction func signUpButton(_ sender: AnyObject) {
        let storyboard : UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        let VC : SignUpViewController = storyboard.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    @IBAction func forgetPasswordButton(_ sender: AnyObject) {

        let alert = UIAlertController(title: "Reset password", message: "Enter your email address", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Email"
        
        }
        
        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (_) in
            let textField = alert.textFields![0]
            let email = textField.text!
            let firAuth = FIRAuth.auth()
            firAuth?.sendPasswordReset(withEmail: email, completion: {
                error in
                if error != nil {
                    self.showAlert(mainTitle: "Error", message: "Please check your email and try again.", actionTitle: "Ok")
                }else{
                    self.showAlert(mainTitle: "Reset email sent successfully.", message: "Please check your email to reset the password.", actionTitle: "Ok")
                }
            })
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //Setting the placeholder string and color of uitextfield
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSForegroundColorAttributeName : UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }

    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension ViewController{
    func showAlert(mainTitle:String, message: String, actionTitle: String){
        let alert = UIAlertController(title: mainTitle, message: message, preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


