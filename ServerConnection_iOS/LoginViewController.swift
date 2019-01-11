//
//  LoginViewController.swift
//  ServerConnection_iOS
//
//  Created by Megavision Technologies on 10/01/19.
//  Copyright © 2019 Megavision Technologies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: CustomTextField!
    
    @IBOutlet weak var pwdText: CustomTextField!
    
    var (email, password) = ("", "")
    
 override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "Login"
        pwdText.isSecureTextEntry = true
        
    }

    @IBAction func signIn(_ sender: UIButton) {
        
        email = (emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        password = (pwdText.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        if isValueEmpty(email: email, password: password) {
            print("Please enter the values")
        }
        else {
            signIn(email:email, password:password)
        }
    
    }
    
    func signIn(email:String , password:String) {
       
        var response1 = ""
        
        //URL to our web service
        let URL_RETRIEVE = "http://192.168.1.128/iOS/retreiveadmin.php?email=\(email)&password=\(password)"
        
       
        //created NSURL
        let requestURL = NSURL(string: URL_RETRIEVE)
        
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to get
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            
            
            //exiting if there is some error
            if error != nil{
                print("error is \(String(describing: error))")
            
                return;
            }
    
            //parsing the response
            do {
                
                let json =  try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? String
                
                 response1 = (json?.description)!
                 print("json.....",response1)
                
                if (response1 == "not matched") || (response1.count == 0) {
                    print("E-mail Id or password not matched.")
                }
                
                else {
                    
                    var resArr = [String]()
                    
                    resArr = (response1.components(separatedBy: ","))
                    
                    let response2 = resArr[0];
                    let email1 = resArr[1];
                    let pwd1 = resArr[2];
                    
                    print(response2+email1+pwd1)
                    
                    if response2 == "matched" {
                    
                        print("Login successful")
                   
                    }
                    
                    else {
                        print("Incorrect E-mail Id or password.")
                    }
                    
                }
            } catch {
                print("Error Serializing JSON: \(error)")
            }
            
            
    
    }
     
    //executing the task
    task.resume()
        
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    func isValueEmpty(email: String , password : String) -> Bool {
        if email.count == 0 || password.count == 0 {
            return true
        }
        else{
            return false
        }
    }
}

