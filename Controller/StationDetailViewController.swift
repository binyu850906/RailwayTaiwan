//
//  StationDetailViewController.swift
//  RailwayTaiwan
//
//  Created by binyu on 2021/7/4.
//

import UIKit

class StationDetailViewController: UIViewController {

    var station: Station?
    var stationID = ""
    var stationName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let station = station{
            stationName = station.StationName.Zh_tw
            stationID = station.StationID
           
            navigationItem.title = stationName + "車站"
        }
    }
    

 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let north = segue.destination as? NorthTrainViewController, let station = station {
            north.station = station
        }
        if let south = segue.destination as? SouthTrainViewController , let station = station {
            south.station = station
        }
    }
    

}
