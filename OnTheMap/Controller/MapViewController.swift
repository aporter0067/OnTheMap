//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Adam Porter on 7/20/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!

    
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func addPin(_ sender: Any) {
        
        self.performSegue(withIdentifier: "completeAddPinSegue", sender: nil)
    }
    
    
    
    
    @IBAction func refreshButton(_ sender: Any) {
    }
    
    
}

