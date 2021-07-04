//
//  networkController.swift
//  RailwayTaiwan
//
//  Created by binyu on 2021/7/3.
//

import Foundation
import UIKit

class NetworkController {
    static let shared = NetworkController()
    
    var stationID = ""
    func downloadData( complition: @escaping (Result<[Station], Error>) -> Void ) {
        let url = URL(string: "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/Station?$select=StationID%2C%20StationName%2C%20StationPosition%2C%20StationClass&$orderby=StationID&$format=JSON")!
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let loadData = try decoder.decode([Station].self, from: data)
                    Station.saveFile(station: loadData)
                    complition(.success(loadData))
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }
    
    func downloadStationData(completion: @escaping (Result<[StationDetail],Error>) -> Void) {
        let url = URL(string: "https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/\(stationID)?$format=JSON")!
        print(url)
        var request = URLRequest(url: url)
        request.setValue(xdate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        request.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let loadData = try decoder.decode([StationDetail].self, from: data)
                    completion(.success(loadData))
                    print("ok")
                } catch  {
                    print("error")
                    print(error)
                }
            }
        }.resume()
    }

}
