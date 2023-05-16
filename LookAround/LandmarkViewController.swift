//
//  ViewController.swift
//  LookAround
//
//  Created by Tim Mitra on 2023-05-16.
//

import UIKit
import MapKit

class LandmarkViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var preview: UIView!
    @IBOutlet var mapView: MKMapView!
    
    private var lookAroundViewController: MKLookAroundViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // grab lookAroundView instance
        if segue.identifier == "presentLookAroundEmbedded" {
            if let lookAroundViewController = segue.destination as? MKLookAroundViewController {
                self.lookAroundViewController = lookAroundViewController
            }
        }
    }
    
    @IBAction func landmark(_ sender: UISegmentedControl) {
        
        let request = MKLocalSearch.Request()
        
        if sender.selectedSegmentIndex == 0{
            request.naturalLanguageQuery = "CN Tower"
        } else if sender.selectedSegmentIndex == 1 {
            request.naturalLanguageQuery = "ScotiaBank Arena"
        } else if sender.selectedSegmentIndex == 2 {
            request.naturalLanguageQuery = "Art Gallery of Ontario"
        }
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else { return }
            if let item = response.mapItems.first {
                UIView.animate(withDuration: 6) {
                    // Camera animation
                    let camera = MKMapCamera(lookingAt: item, forViewSize: self.mapView.frame.size, allowPitch: true)
                    self.mapView.camera = camera
                } completion: { _ in
                    // Prepare LookAround view
                    self.configureLookAroundScene(item)
                }
            }
        }
    }
    
    func configureLookAroundScene(_ item: MKMapItem) {
        guard let lookAroundViewController = self.lookAroundViewController else { return }
        let lookAroundRequest = MKLookAroundSceneRequest(mapItem: item)
        
        Task {
          // create lookAround scene request
            do {
                // Issue request
                guard let lookAroundScene = try await lookAroundRequest.scene else { return }
                lookAroundViewController.scene = lookAroundScene
                // Show lookAround Preview
                self.preview.isHidden = false
            } catch {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set initial location in Toronto
        let initialLocation = CLLocation(latitude: 43.6529, longitude: -79.3849)

        mapView.centerToLocation(initialLocation)
    }
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}


