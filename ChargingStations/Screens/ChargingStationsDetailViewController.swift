//
//  ChargingStationsDetailViewController.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class ChargingStationsDetailViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblStations: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var imgOperational: UIImageView!
    @IBOutlet weak var lblOperational: UILabel!
    
    
    //MARK:- Variables
    var viewModel: HomeDetailViewModel?
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK:- UI setup
    func setupUI() {
        guard let station = viewModel?.station else { return }
        lblTitle.text = station.address?.title
        lblSubtitle.text = station.formattedAddress
        lblStations.text = station.chargingPoints
        if station.statusType?.isOperational == 1 {
            imgOperational.image = UIImage(named: "smile")
            lblOperational.text = "Operational"
            lblOperational.textColor = UIColor.green
        }
        else {
            imgOperational.image = UIImage(named: "sad")
            lblOperational.text = "Not Operational"
            lblOperational.textColor = UIColor.red
        }
        viewModel?.getDistance(completion: { [weak self] (distance) in
            self?.lblDistance.text = distance
        })
    }

    @IBAction func navvigate(_ sender: Any) {
        guard let station = viewModel?.station else { return }
        guard let address = station.address, let lat = address.latitude, let lng = address.longitude else { return }
        let source = MKMapItem(coordinate: .init(latitude: User.shared.latitude, longitude: User.shared.longitude), name: "Source")
        let destination = MKMapItem(coordinate: .init(latitude: lat, longitude: lng), name: "Destination")

        MKMapItem.openMaps(
          with: [source, destination],
          launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )
    }
    
    @IBAction func share(_ sender: Any) {
        guard let station = viewModel?.station else { return }
        guard let address = station.address, let lat = address.latitude, let lng = address.longitude else { return }
        
        if let shareObject = MapHelper.activityItems(latitude: lat, longitude: lng) {
               //open UIActivityViewController
            let activityController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            present(activityController, animated:true, completion: nil)
        }
    }
}
