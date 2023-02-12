//
//  ChargingStationsMapViewController.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import Foundation
import UIKit
import MapKit

class ChargingStationsMapViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var viewMap: MKMapView!
    
    //MARK:- Variables
    var user = User.shared
    var distance: Int = 5
    var viewModel: HomeViewModel? {
        didSet {
            self.viewModel?.delegate = self
        }
    }
    var chargingStations: [Station]?
    weak var timer: Timer?
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    //MARK:- UI setup
    func setupUI() {
        viewMap.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: user.latitude, longitude: user.longitude), latitudinalMeters: 2000, longitudinalMeters: 2000), animated: false)
        viewMap.delegate = self
        self.viewModel = HomeViewModel()
        getChargingStationsAPI()
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
            self?.getChargingStationsAPI()
        }
    }
    
    //MARK:- Functionalities
    func getChargingStationsAPI(){
        self.viewModel?.getStations(latitude: user.latitude, longitude: user.longitude, distance: distance)
    }
    
    func updateAnnotations() {
        //remove annotaions no longer returned in chargingStations array
        let stationIds = chargingStations?.map({$0.address?.id}) ?? []
        let removeAnnotations = self.viewMap.annotations
            .compactMap { $0 as? StationAnnotation }
            .filter { (annotation) -> Bool in
                return !stationIds.contains(annotation.stationId)
            }
        self.viewMap.removeAnnotations(removeAnnotations)
        
        //update existing station coordinate or add new station pin if not already added
        for station in chargingStations ?? [] {
            if let existingMarker = self.viewMap.annotations.first(where: {($0 as? StationAnnotation)?.stationId == station.address?.id}) as? StationAnnotation {
                existingMarker.coordinate = CLLocationCoordinate2D(latitude: station.address?.latitude ?? 0, longitude: station.address?.longitude ?? 0)
            }
            else {
                let annotation = StationAnnotation(coordinate: CLLocationCoordinate2D(latitude: station.address?.latitude ?? 0, longitude: station.address?.longitude ?? 0), stationId: station.address?.id ?? 0, isOperational: station.statusType?.isOperational == 1)
                self.viewMap.addAnnotation(annotation)
            }
        }
    }
}

extension ChargingStationsMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = viewMap.dequeueReusableAnnotationView(withIdentifier: "chargingStationPin")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "chargingStationPin")
        }
        else{
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "charging")
        if let model = annotation as? StationAnnotation {
            if !model.isOperational{
                annotationView?.image = UIImage(named: "charging_disabled")
            }
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.performSegue(withIdentifier: "showStationDetail", sender: view.annotation)
    }
}

//MARK:- APIs response handling
extension ChargingStationsMapViewController: HomeViewModelProtocol {
    func handleViewModelOutput(_ output: HomeViewModelOutput) {
        switch output {
        case .getStationsResponse(let response):
            self.chargingStations = response
            DispatchQueue.main.async { [weak self] in
                self?.updateAnnotations()
            }
        }
    }
}

extension ChargingStationsMapViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStationDetail" {
            if let viewController = segue.destination as? ChargingStationsDetailViewController, let annotation = sender as? StationAnnotation {
                guard let station = chargingStations?.first(where: { $0.address?.id == annotation.stationId}) else { return }
                viewController.viewModel = HomeDetailViewModel(station: station)
            }
        }
    }
}
