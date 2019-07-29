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
    
    func showModal(cameraHandel: String) {
        let modalViewController = storyboard?.instantiateViewController(withIdentifier: "modal") as! ModalViewController
        modalViewController.modalPresentationStyle = .overCurrentContext
        modalViewController.parkingService = viewModel
        modalViewController.url = cameraHandel
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.startUpdatingLocation()
        viewModel.getParkings(location: currentLocation, dist: 15, max: nil, completion: { result in
            self.parkings.removeAll()
            self.parkings.append(contentsOf: result.value!)
            self.tableView.reloadData()
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
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let parking = parkings[indexPath.row]
//        let handle =
//        showModal()
//        print("Clicked \(indexPath)")
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ParkingCell
        print("userinteractionenavbled: \(cell.isUserInteractionEnabled)")
        let parking = parkings[indexPath.row]
        cell.title?.text = parking.name
        cell.cameraImageOne.isHidden = true
        cell.cameraImageTwo.isHidden = true
        cell.subtitleOne.text = "Parking spaces: \(parking.totalCapacity)"
        if (parking.freeSpaces != nil){
            cell.subtitleTwo.text = "Free spaces: \(parking.freeSpaces!)"
            cell.subtitleTwo.isHidden = false
        } else {
            cell.subtitleTwo.isHidden = true
        }
        if (parking.parkingCameras != nil){
            let camera = parking.parkingCameras!
            if (camera.count == 1){
                cell.cameraImageOne.isHidden = false
                cell.cameraImageOne.url = "/\(parking._id)/1"
            
            }
            if (camera.count == 2){
                cell.cameraImageOne.isHidden = false
                cell.cameraImageOne.url = "/\(parking._id)/1"
                cell.cameraImageTwo.isHidden = false
                cell.cameraImageTwo.url = "/\(parking._id)/2"
            }
        }
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:)))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:)))
        cell.cameraImageOne.addGestureRecognizer(tapGesture1)
        // make sure imageView can be interacted with by user
        cell.cameraImageOne.isUserInteractionEnabled = true
        cell.cameraImageTwo.addGestureRecognizer(tapGesture2)
        // make sure imageView can be interacted with by user
        cell.cameraImageTwo.isUserInteractionEnabled = true
        
        return cell
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        
        if (gesture.view as? CustomImageView) != nil {
            let image = gesture.view as? CustomImageView
            print("Image Tapped" + image!.url!)
            showModal(cameraHandel: image!.url!)
            //Here you can initiate your new ViewController
            
        }
    }
}

