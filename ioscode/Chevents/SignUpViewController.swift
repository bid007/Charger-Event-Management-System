//
//  SignUpViewController.swift
//  
//
//  Created by Bid Sharma on 9/17/16.
//
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UITableViewController {
    @IBOutlet weak var userType: UISegmentedControl!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var repassword: UITextField!
    @IBOutlet weak var gender: UISegmentedControl!
    let firAuth = FIRAuth.auth()
    
    
    @IBAction func signUp(_ sender: AnyObject) {
        let userType: String = (self.userType.selectedSegmentIndex == 0) ? "user" : "organization"
        
        if(userType == "user"){
            let fName: String = self.firstName.text!
            let lName: String = self.lastName.text!
            let email: String = self.email.text!
            let password: String = self.password.text!
            let gender: String = (self.gender.selectedSegmentIndex == 0) ? "Male" : "Female"
            //Validate these values
            let userDetail:[String:String] = ["fname":fName, "lname":lName, "email":email, "password":password, "gender":gender]
            self.userSignUp(userInfo: userDetail)
            
        }else{
            let organizationName: String = self.firstName.text!
            let email: String = self.email.text!
            let password: String = self.password.text!
            //validate these values
            let orgInfo:[String:String] = ["name": organizationName, "email": email, "password": password]
            self.orgSignUp(orgInfo: orgInfo)
        }
    }
    
    func orgSignUp(orgInfo:[String:String]){
        firAuth?.createUser(withEmail: orgInfo["email"]!,
                            password: orgInfo["password"]!,
                            completion: {
                                (user, error) in
                                if user != nil{
                                    self.saveCreatedUser(userInfo: orgInfo, uid: (user?.uid)!, isUser: false)
                                }else{
                                    print("Here is something wrong \(error)")
                                    let alert = UIAlertController(title:"Error!!!", message:error?.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        )
    }
    
    func userSignUp(userInfo:[String:String]){
        firAuth?.createUser(withEmail:userInfo["email"]!,
                            password: userInfo["password"]!,
                            completion: {
                                (user, error) in
                                if user != nil{
                                    self.saveCreatedUser(userInfo: userInfo, uid: (user?.uid)!, isUser: true)
                                }else{
                                    let alert = UIAlertController(title:"Error!!!", message:error?.localizedDescription, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                        )
    }
    
    func saveCreatedUser(userInfo:[String:String], uid:String, isUser:Bool){
        let url:String = isUser ? "user/create":"organization/create"
        var info = userInfo
        info.updateValue(uid,forKey:"uid")
        RestApiManager.sharedInstance.createUser(
                                        userInfo: info,
                                        url: url,
                                        onCompletion: {
                                            (json) in
                                            let success: Bool = json["status"] == 1
                                            let successMsg = success ? "Success" : "Error"
                                            let message = json["msg"].stringValue
                                            let actionTitle = success ? "Sign In" : "Retry"
                                            OperationQueue.main.addOperation({
                                                //Do the main ui stuff here
                                                let alert = UIAlertController(title:successMsg, message:message, preferredStyle: .alert)
                                                alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (_) in
                                                    if(success){
                                                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                                        let VC : ViewController = storyboard.instantiateViewController(withIdentifier: "signin") as! ViewController
                                                        self.navigationController?.pushViewController(VC, animated: true)
                                                    }else{
                                                        self.firAuth?.currentUser?.delete(completion:{(error) in print(error as Any)})
                                                    }
                                                }))
                                                self.present(alert, animated: true, completion: nil)
                                            })//closing bracket of OpertaionQueue
                                        })//closing bracket of restapi call
    }
    
    @IBAction func userTypeAction(_ sender: AnyObject) {
        let userLabel: String = (userType.selectedSegmentIndex == 0) ? "First Name":"Organization Name"
        //for user selected hidden value is false
        //for organization selected hidden value is true
        let hiddenValue: Bool = (userType.selectedSegmentIndex == 1)
        lastName.isHidden = hiddenValue
        gender.isHidden = hiddenValue
        firstName.attributedPlaceholder = NSAttributedString(string: userLabel, attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //close keyboard on tap screen
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //Changing the color of placeholder
        firstName.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        lastName.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName : UIColor.white])
        email.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName : UIColor.white])
        password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
        repassword.attributedPlaceholder = NSAttributedString(string: "Retype your Password", attributes: [NSForegroundColorAttributeName : UIColor.white])
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

