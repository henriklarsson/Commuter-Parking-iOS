//
//  ViewController.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-14.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var parkings = [ParkingLot]()
    let viewModel = ParkingService()
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    var initWithLocation = false
    
    @IBOutlet weak var tableView: UITableView!
    
    func showModal() {
        let modalViewController = ModalViewController()
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.parkingService = viewModel
//        modalViewController.view.backgroundColor = UIColor.red
        present(modalViewController, animated: true)

    }

    override func viewDidLoad() {
//        super.viewDidLoad()
//        public var lat: Double
//        public var _id: Int
//        /** Only available if ParkingType Name is SMARTCARPARK */
//        public var parkingCameras: [ParkingCamera]?
//        public var lon: Double
//        public var isRestrictedByBarrier: Bool
//        /** Number of free spaces. Only available if ParkingType Name is SMARTCARPARK */
//        public var freeSpaces: Int?
        tableView.delegate = self
        tableView.dataSource = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        viewModel.getParkings(location: currentLocation, dist: 15, max: nil, completion: { result in
            self.parkings.removeAll()
            self.parkings.append(contentsOf: result.value!)
            self.tableView.reloadData()
            self.showModal()
        })
        
        
        // Do any additional setup after loading the view.
    }

}
extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parkings.count
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.currentLocation = locValue
        self.locationManager?.stopUpdatingLocation()
        if (!initWithLocation){
            self.initWithLocation = true
            viewModel.getParkings(location: currentLocation, dist: 15, max: nil, completion: { result in
                self.parkings.removeAll()
                self.parkings.append(contentsOf: result.value!)
                self.tableView.reloadData()
            })
        }
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ParkingCell
        let parking = parkings[indexPath.row]
        cell.title?.text = parking.name
        cell.subtitleOne.text = "Parking spaces: \(parking.totalCapacity)"
        if (parking.freeSpaces != nil){
            cell.subtitleTwo.text = "Free spaces: \(parking.freeSpaces!)"
            cell.subtitleTwo.isHidden = false
        } else {
            cell.subtitleTwo.isHidden = true
        }
    
        return cell
    }
}

