//
//  ViewController.swift
//  ChallengeExperience2
//
//  Created by Michael Flowers on 9/28/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    let experienceController = ExperienceController()
    
    @IBOutlet weak var mapView: MKMapView!
    private lazy var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnnotationView")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addAnnotation()
    }
    
    func requestAuthorization(){
        //ask permission to use location, make applicable changes in info.plist
        locationManager.requestWhenInUseAuthorization()
        
        //check to see which permission they've allowed.
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedWhenInUse:
            break
        case .denied:
            break
        case .notDetermined:
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            fatalError()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latitude = locations[0].coordinate.latitude
        let longitude = locations[0].coordinate.longitude
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ToExperience", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToExperience" {
            let destionationVC = segue.destination as! ExperienceViewController
            destionationVC.experienceController = experienceController
            destionationVC.coordinate = coordinate
        }
    }
    
     func addAnnotation(){
        for annotation in experienceController.experiences {
            let mkPointAnnotation = MKPointAnnotation()
            mkPointAnnotation.coordinate = annotation.coordinate
            mkPointAnnotation.title = experienceController.experiences.first?.name
            mapView.addAnnotation(annotation)
        }
    }
}

