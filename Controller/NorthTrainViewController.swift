//
//  NorthTrainViewController.swift
//  RailwayTaiwan
//
//  Created by binyu on 2021/7/4.
//

import UIKit

class NorthTrainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    var station: Station?
    var train = [StationDetail]()
    @IBOutlet weak var northTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkController.shared.stationID = station!.StationID
        
        NetworkController.shared.downloadStationData {  result in
            switch result {
            case .success(let loadData):
                
                    for station in loadData {
                        if station.Direction == 0 {
                            self.train.append(station)
                        }
                    }
                DispatchQueue.main.async {
                    self.northTableView.reloadData()
                }
                
            case .failure(let error):
                print("error result")
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(train.count)
        return train.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? StationDetailTableViewCell else { return StationDetailTableViewCell() }
        
        let timeString = train[indexPath.row].ScheduledDepartureTime
        
        let time = String(timeString.prefix(5))
        cell.textLabel?.text = time
        
        let trainType = train[indexPath.row].TrainTypeName.Zh_tw.split(separator: "(")[0]
        cell.trainType_N.text = String(trainType)
        cell.endStation_N.text = train[indexPath.row].EndingStationName.Zh_tw
        
        let delay = train[indexPath.row].DelayTime
        cell.delay_N.layer.masksToBounds = true
        cell.delay_N.layer.cornerRadius = 10
        
        if delay > 10 {
            cell.delay_N.backgroundColor = .systemPink
            cell.delay_N.text = "晚\(delay)分"
        }else {
            cell.delay_N.text = "準點"
        }
        return cell
    }
    
 
   
}
