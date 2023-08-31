//
//  ViewController.swift
//  21TI026-MyMap
//
//  Created by 川村空千 on 2023/08/30.
//

import UIKit
import MapKit

struct Location {
    let latitude: Double
    let longitude: Double
    let name: String
}

protocol LocationDelegate: AnyObject {
    func create(data: Location)
    func read() -> [Location]
    func setLocation(location: Location)
}

class ViewController: UIViewController, CLLocationManagerDelegate, LocationDelegate {

    let manager = CLLocationManager()
    var locations: [Location] = []

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let current = locations[0]
        let region = MKCoordinateRegion(center: current.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView?.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error = \(error)")
    }
    
    func create(data: Location) {
        locations.append(data)
    }

    func read() -> [Location] {
        return locations
    }
    
    func setLocation(location: Location) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        print("COORDINATE \(coordinate)")
        // set region from selected location and focus to it
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView?.setRegion(region, animated: true)

        // add pin to selected location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = location.name
        mapView?.addAnnotation(pin)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? FormViewController {
            let current = mapView.userLocation.coordinate
            vc.current = current
            vc.delegate = self
        } else if let vc = segue.destination as? GeoListViewController {
            vc.delegate = self
        }
    }
}

