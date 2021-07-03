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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
