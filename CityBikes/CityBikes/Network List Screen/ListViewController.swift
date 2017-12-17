//
//  RootViewController.swift
//  CityBikes
//
//  Created by Meenakshi katal on 12/10/17.
//  Copyright © 2017 Meenakshi Katal. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController,UISearchBarDelegate {
    
    var networkArray : [Network] = []
    var stationArray : [Station] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredNetworkArray: [Network]?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeActivityIndicatorState()

        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self;
        tableView.tableHeaderView = searchController.searchBar
        
        // Do any additional setup after loading the view, typically from a nib.
        getCityBikesInformation()
        self.tableView.estimatedRowHeight = 60.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
}
    override func viewWillDisappear(_ animated: Bool) {
        
        self.searchController.searchBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.searchController.searchBar.isHidden = false
        self.tableView.reloadData()

    }
    
    // MARK: - API Calls
func getCityBikesInformation() {
    
    let networkMgr = NetworkManager()
    networkMgr.getCityBikesList(failure: { (reason, error) in
        DispatchQueue.main.async {
            self.changeActivityIndicatorState(false)
            if (error.code == -1009) {
                self.showAlert("Network Error", message: "Please check your internet connection.")
            } else {
                self.showAlert("Service Error", message: "Server is not working at this time, please try later.")
            }
        }
    }) { (networkObj) in
        DispatchQueue.main.async {
           self.changeActivityIndicatorState(false)
            self.networkArray = networkObj.networks
            self.filteredNetworkArray = self.networkArray
            self.tableView.reloadData()
        }
    }
}
    
    func getCityBikesInformationForNetworkId(_ networkId:String) {
        let networkMgr = NetworkManager()
        networkMgr.getCityBikeDetails(networkId, failure: { (reason, error) in
            DispatchQueue.main.async {
                self.changeActivityIndicatorState(false)
                if (error.code == -1009) {
                    self.showAlert("Network Error", message: "Please check your internet connection.")
                } else {
                    self.showAlert("Service Error", message: "Server is not working at this time, please try later.")
                }
            }
        }) { (networkObj) in
            DispatchQueue.main.async {
                self.changeActivityIndicatorState(false)
                self.stationArray = networkObj.network.stations
                self.performSegue(withIdentifier: "GoToDetailScreen", sender: nil)
            }
        }
    }

    func saveResponseData(responseDict: Dictionary<String, Any>) {
        print(responseDict)
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredArray = self.filteredNetworkArray else {
            return 0
        }
        return filteredArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)
       
        if let filteredArray = self.filteredNetworkArray {
            let networkObj = filteredArray[indexPath.row]
            cell.textLabel!.text = networkObj.name
            cell.detailTextLabel?.text = networkObj.location.city
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.changeActivityIndicatorState(true)
        let networkObj = networkArray[indexPath.row]
        getCityBikesInformationForNetworkId(networkObj.id)
    }
    
    //MARK: Search Result
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            self.filteredNetworkArray = self.networkArray.filter { team in
                return team.name.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            self.filteredNetworkArray = self.networkArray
        }
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! DetailViewController
        detailVC.stationArray = stationArray
    }
}





