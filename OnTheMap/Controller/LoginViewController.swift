//
//  ViewController.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/15/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var udacityLogo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginButton(_ sender: Any) {
        UdacityClient.createSessionId(self.emailTextField.text ?? "", self.passwordTextField.text ?? "")
        { (success: Bool, error: Error?) in
            
            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
            }
        }
    }
    
    
    @IBAction func loginViaFacebook(_ sender: Any) {
        
    }
    
    
    
    
    
}

