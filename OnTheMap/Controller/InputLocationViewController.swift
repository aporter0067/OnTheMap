//
//  InputLocationViewController.swift
//  OnTheMap
//
//  Created by Adam Porter on 8/1/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class InputLocationViewController: UIViewController {
    
    @IBOutlet weak var enterLocationTextField: UITextField!
    @IBOutlet weak var titleLable: UILabel!
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func findOnMapButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "findOnMapSegue", sender: nil)
    }
    
    
}
