//
//  StationAnnotationView.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import Foundation
import MapKit

final class StationAnnotation: NSObject, MKAnnotation{
    var stationId: Int
    var isOperational: Bool
    var title: String?
    
    dynamic var coordinate: CLLocationCoordinate2D
    init(coordinate: CLLocationCoordinate2D, stationId: Int, isOperational: Bool) {
        self.coordinate = coordinate
        self.stationId = stationId
        self.isOperational = isOperational
        super.init()
    }
}
