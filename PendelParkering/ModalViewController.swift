//
//  ModalViewController.swift
//  PendelParkering
//
//  Created by Larsson, Henrik (94777) on 2019-06-04.
//  Copyright © 2019 Larsson, Henrik (94777). All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class ModalViewController: UIViewController {
    @IBOutlet weak var parkingImageView: UIImageView!
    
    @IBOutlet weak var rootView: UIView!
    var parkingService: ParkingService? = nil
    var url: String? = nil
    
    
    
    override func viewDidLoad() {
//        imageView.dowloadFromServer(link: "http://html.cita.illinois.edu/text/test/images/img-ais3.2.png")
        super.viewDidLoad()
        let currentUrl = "https://api.vasttrafik.se/spp/v3/parkingImages" + self.url!
        parkingService?.downloadImage(imageUrl: currentUrl, completion: {result in
            let size = CGSize(width: 400, height: 400)
            let cgRect = CGRect(x: 0, y: 0, width: 100, height: 100)
            let imageView = UIImageView(frame: cgRect)
            self.parkingImageView.image = result.value!
            let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.tapDetected))
            self.parkingImageView.isUserInteractionEnabled = true
            self.parkingImageView.addGestureRecognizer(singleTap)
            self.rootView.isUserInteractionEnabled = true
            self.rootView.addGestureRecognizer(singleTap)
           
            print("success")
//            self.view.addSubview(imageView)
        })
        
    }
    @objc func tapDetected() {
        print("Imageview Clicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
//    func downloadImage(imageUrl: String) {
//         let headers =  ["Authorization": "Bearer " + token]
//        Alamofire.request(imageUrl, method: .get, headers: headers).responseImage { response in
//            guard let image = response.result.value else {
//                print("error")
//                return
//            }
//
//
//            // Do stuff with your image
//        }
//    }
    
}
//extension UIImageView {
//    func dowloadFromServer(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//    func dowloadFromServer(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        dowloadFromServer(url: url, contentMode: mode)
//    }
//}
