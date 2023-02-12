//
//  MapHelper.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/11/23.
//

import Foundation
import CoreLocation
import MapKit
import CoreServices

class MapHelper {
    
    static func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping (Double?) -> Void) {
        
        routes(from: MKMapItem(placemark: MKPlacemark(coordinate: from)), to: MKMapItem(placemark: MKPlacemark(coordinate: to))) { (routes, error) in
            guard let routes = routes, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion(nil)
                return
            }
            guard let route = routes.first else { completion(0); return }
            let distance = route.distance / 1000
            completion(distance)
        }
    }
    
    static func routes(from:MKMapItem,  to: MKMapItem, completion: @escaping ([MKRoute]?, Error?) -> Void) {
        let request = MKDirections.Request()
        request.source = from
        request.destination = to
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            completion(response?.routes, error)
        }
    }
    
    static func activityItems(latitude: Double, longitude: Double) -> [AnyObject]? {
        var items = [AnyObject]()
        
        let URLString = "https://maps.apple.com?ll=\(latitude),\(longitude)"
        
        if let url = NSURL(string: URLString) {
            items.append(url)
        }
        
        let locationVCardString = [
            "BEGIN:VCARD",
            "VERSION:3.0",
            "N:;Shared Location;;;",
            "FN:Shared Location",
            "item1.URL;type=pref:http://maps.apple.com/?ll=\(latitude),\(longitude)",
            "item1.X-ABLabel:map url",
            "END:VCARD"
        ].joined(separator: "\n")
        
        
        guard let vCardData : NSSecureCoding = locationVCardString.data(using: .utf8) as NSSecureCoding? else {
            return nil
        }
        
        let vCardActivity = NSItemProvider(item: vCardData, typeIdentifier: kUTTypeVCard as String)
        
        items.append(vCardActivity)
        
        return items
    }
}

extension MKMapItem {
    convenience init(coordinate: CLLocationCoordinate2D, name: String) {
        self.init(placemark: .init(coordinate: coordinate))
        self.name = name
    }
}
