//
//  TRAStationTableViewController.swift
//  RailwayTaiwan
//
//  Created by binyu on 2021/7/3.
//

import UIKit

class TRAStationTableViewController: UITableViewController, UISearchResultsUpdating {
   
    
    
    var stations = [Station]()
    var searchStations = [Station]()
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkController.shared.downloadData { result in
            switch result {
            case .success(let data) :
                self.stations = data
            case .failure(let error) :
                print(error)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
       setSearchController()
    }
    
    func setSearchController () {
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController?.obscuresBackgroundDuringPresentation = false
        searchController?.searchBar.placeholder = "搜尋火車站"
        searchController?.searchBar.tintColor = .red
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchStations = stations.filter({ name -> Bool in
                return name.StationName.Zh_tw.contains(searchText)
            })
            tableView.reloadData()
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(stations.count)
        
        if searchController?.isActive == true{
            return searchStations.count
        }else {
            return stations.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TRAStationTableViewCell", for: indexPath)
        
        if searchController?.isActive == true {
            cell.textLabel?.text = searchStations[indexPath.row].StationName.Zh_tw
        }else {
            cell.textLabel?.text = stations[indexPath.row].StationName.Zh_tw
        }
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StationDetail" {
            if let detail = segue.destination as? StationDetailViewController, let row = tableView.indexPathForSelectedRow?.row {
                if searchController?.isActive == true {
                    detail.station = searchStations[row]
                }else {
                    detail.station = stations[row]
                }
            }
        }
    }
}
