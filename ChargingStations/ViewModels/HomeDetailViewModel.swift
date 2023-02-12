//
//  HomeDetailViewModel.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/11/23.
//

import Foundation
import CoreLocation

class HomeDetailViewModel {
    var station: Station?
    init(station: Station) {
        self.station = station
    }
    
    func getDistance(completion: @escaping (String) -> Void) {
        guard let address = station?.address, let lat = address.latitude, let lng = address.longitude else {
            completion("-")
            return
        }
        let from = CLLocationCoordinate2D(latitude: User.shared.latitude, longitude: User.shared.longitude)
        let to = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        MapHelper.getDistance(from: from, to: to) { (distance) in
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 1
            formatter.maximumFractionDigits = 1
            if let distance = distance {
                completion("\(formatter.string(from: NSNumber(value: distance)) ?? "") km")
            }
            else{
                completion("-")
            }
        }
    }
}
