//
//  GeoListViewController.swift
//  21TI026-MyMap
//
//  Created by 川村空千 on 2023/08/31.
//

import UIKit
import MapKit


class GeoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var locations: [Location] = []
    var selected: Location?
    weak var delegate: LocationDelegate?

    @IBOutlet weak var geoList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locations = delegate?.read() ?? []
        geoList?.dataSource = self
        geoList?.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = geoList.dequeueReusableCell(withIdentifier: "NameCell")
        let item = locations[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.setLocation(location: locations[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
}

