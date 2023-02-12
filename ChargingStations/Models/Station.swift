//
//  Movie.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import Foundation

class Station {
    var address: AddressInfo?
    var numberOfPoints: Int?
    var statusType: StatusType?
    var formattedAddress: String {
        var add:[String] = []
        if let add1 = self.address?.addressLine1, !add1.isEmpty {
            add.append(add1)
        }
        if let add2 = self.address?.addressLine2, !add2.isEmpty {
            add.append(add2)
        }
        if let pin = self.address?.postalCode, !pin.isEmpty {
            add.append(pin)
        }
        return add.joined(separator: ", ")
    }
    var chargingPoints: String {
        let points = numberOfPoints ?? 0
        return "\(points) Charging Point\(points == 1 ? "" : "s")"
    }
}

extension Dictionary where Key == String {
    
    func toStationModel() -> Station {
        let model = Station()
        model.numberOfPoints = self["NumberOfPoints"] as? Int
        model.address = (self["AddressInfo"] as? [String: Any])?.toAddressInfoModel()
        model.statusType = (self["StatusType"] as? [String: Any])?.toStatusModel()
        return model
    }
    
    func toAddressInfoModel() -> AddressInfo {
        let model = AddressInfo()
        model.id = self["ID"] as? Int
        model.title = self["Title"] as? String
        model.latitude = self["Latitude"] as? Double
        model.longitude = self["Longitude"] as? Double
        model.addressLine1 = self["AddressLine1"] as? String
        model.addressLine2 = self["AddressLine2"] as? String
        model.town = self["Town"] as? String
        model.state = self["StateOrProvince"] as? String
        model.postalCode = self["Postcode"] as? String
        return model
    }
    
    func toStatusModel() -> StatusType {
        let model = StatusType()
        model.isOperational = self["IsOperational"] as? Int ?? 0
        return model
    }

}

class AddressInfo {
    var id: Int?
    var title: String?
    var latitude: Double?
    var longitude: Double?
    var addressLine1: String?
    var addressLine2: String?
    var town: String?
    var state: String?
    var postalCode: String?
}

class StatusType {
    var isOperational: Int = 0
}
