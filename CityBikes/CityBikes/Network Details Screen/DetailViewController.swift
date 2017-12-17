//
//  DetailViewController.swift
//  CityBikes
//
//  Created by Meenakshi katal on 12/17/17.
//  Copyright © 2017 Meenakshi Katal. All rights reserved.
//

import UIKit

class DetailViewController: BaseViewController {
    var stationArray : [Station] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (stationArray.count);
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NetworkDetailTableViewCell", for: indexPath) as! NetworkDetailTableViewCell
        
        let networkObj = stationArray[indexPath.row]
        cell.stationName?.text = networkObj.name
        cell.freeBikes?.text = String(networkObj.freeBikes)
        cell.freeSlots?.text = String(networkObj.emptySlots)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
