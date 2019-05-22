//
//  ViewController.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-05-14.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    var parkings = [ParkingLot]()
    @IBOutlet weak var table: UITableView!
    

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
        let parkingType = ParkingType(name: ParkingType.Name.smartcarpark, number: 1)
        let parking1 = ParkingLot.init(name: "ParkingSpaceName", totalCapacity: 2, parkingType: parkingType, lat: Double(2), _id: 3, parkingCameras: nil, lon: Double(3), isRestrictedByBarrier: false, freeSpaces: 2)
        parkings.append(parking1)
        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return parkings.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        cell.textLabel?.text = parkings[indexPath.row].name
        
        return cell
    }


}

