//
//  ViewController.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-14.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    var parkings = [ParkingLot]()
    let viewModel = ParkingService()
    @IBOutlet weak var tableView: UITableView!
    
    

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
        viewModel.getParkings(completion: { result in
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

