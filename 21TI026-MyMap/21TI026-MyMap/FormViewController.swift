//
//  FormViewController.swift
//  21TI026-MyMap
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit
import MapKit

class FormViewController: UIViewController{
    var current: CLLocationCoordinate2D?
    weak var delegate: LocationDelegate?

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // set addressLabel from current location
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: current!.latitude, longitude: current!.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                let address = "\(placemark.administrativeArea ?? "") \(placemark.locality ?? "") \(placemark.name ?? "")"
                self.addressLabel.text = address
            }
        }
        self.altitudeLabel.text = "緯度: \(current!.latitude), 経度: \(current!.longitude)"
    }

    func saveLocation() {
        let newLocation = Location(latitude: current!.latitude, longitude: current!.longitude, name: nameField.text!)
        delegate?.create(data: newLocation)
    }

    @IBAction func submitButtonTapped(_ sender: Any) {
        saveLocation()
        self.navigationController?.popViewController(animated: true)
    }
}

