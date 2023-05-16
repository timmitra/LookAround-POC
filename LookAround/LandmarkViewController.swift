//
//  ViewController.swift
//  LookAround
//
//  Created by Tim Mitra on 2023-05-16.
//

import UIKit
import MapKit

class LandmarkViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    
    private var lookAroundViewController: MKLookAroundViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // grab lookAroundView instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

