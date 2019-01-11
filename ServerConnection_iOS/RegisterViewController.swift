//
//  RegisterViewController.swift
//  ServerConnection_iOS
//
//  Created by Megavision Technologies on 10/01/19.
//  Copyright © 2019 Megavision Technologies. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailText: CustomTextField!
   
    @IBOutlet weak var pwdText: CustomTextField!
    
    var (email, password) = ("", "")
    
    //URL to our web service
     let URL_SAVE = "http://192.168.1.128/iOS/insertadmin.php"
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "Register"
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        email = (emailText.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        password = (pwdText.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        if isValueEmpty(email: email, password: password) {
            print("Please enter the values")
            
        }
        else {
            if !isValidEmail(emailID: email) {
                print("Please enter valid Email ID")

            }
           else if !isPwdLenth(password: password) {
                print("Password should be of atleast 6 characters.")
                
            }
            else {
                
                registerData(email: email, password: password)
                
            }
       
        }
       
        
    }
    
    func registerData(email:String , password:String) {
        
        //created NSURL
        let requestURL = URL(string: URL_SAVE)
        
        let request = NSMutableURLRequest(url: requestURL!)
        
        //setting the method to post
        request.httpMethod = "POST"
        
       
        //creating the post parameter by concatenating the keys and values from text field
        let adminDetails = "email="+email+"&password="+password;
        
        //adding the parameters to request body
        request.httpBody = adminDetails.data(using: String.Encoding.utf8)
        
        //creating a task to send the post request
         let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
           
            if error != nil{
                print("server connection failed")
                print("error is \(String(describing: error))")
                return;
            }
            
            //parsing the response
            do {
                
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                //parsing the json
                if let parseJSON = myJSON {
                    
                    //creating a string
                    var response1 : String!
                    
                    //getting the json response
                    response1 = parseJSON["response"] as! String?
                    
                    //printing the response
                    print(response1)
                    
                    if response1 == "Data added successfully" {
                        print("User registered.")
                    }
                    else {
                        print("User not registered.")
                    }
                    
                }
                    
                else {
                    print("data not inserted")
                    
                }
                
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
        
        
        
    }
    
    //to check valid Email-ID
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
    
    //to check password length
    func isPwdLenth(password: String) -> Bool {
        if password.count >= 6 {
            return true
        }else{
            return false
        }
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
