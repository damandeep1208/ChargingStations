//
//  HomeViewModel.swift
//  ChargingStations
//
//  Created by Damandeep Kaur on 2/10/23.
//

import UIKit

protocol HomeViewModelProtocol {
    func handleViewModelOutput(_ output: HomeViewModelOutput)
}

enum HomeViewModelOutput {
    case getStationsResponse([Station]?)
}

class HomeViewModel {
    
    var delegate:HomeViewModelProtocol?
    
    func getStations(latitude: Double, longitude: Double, distance: Int) {
        FetchDataService.fetchData(url: "https://api.openchargemap.io/v3/poi/?output=json&key=\(apiKey)&latitude=\(latitude)&longitude=\(longitude)&distance=\(distance)") { (response, error) in
            let arrModel = response?.map({$0.toStationModel()})
            self.notify(.getStationsResponse(arrModel))
        }
    }
    
    //MARK: call delegates in view controller to handle HomeViewModelOutput
    private func notify(_ output: HomeViewModelOutput  ) {
        delegate?.handleViewModelOutput(output)
    }
}
