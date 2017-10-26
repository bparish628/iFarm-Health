//
//  SafetyTableViewController.swift
//  iFarm-Health
//
//  Created by Benji Parish on 10/23/17.
//  Copyright © 2017 Benji Parish. All rights reserved.
//

import UIKit

/**
     Controller of the TableView of the Safety Page
 */
class SafetyTableViewController: UITableViewController {
    
    // MARK: - Variables
    
    /**
         Contains a list of the selectable sites
     */
    var sites = [Site]()
    
    // MARK: - Functions

    /**
         After view loads, load the sites
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sites
        loadSites()
    }

    /**
         Number of sections in the table
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /**
         Number of rows in the table.
         @return length of sites
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sites.count
    }
    
    private func loadSites() {
        guard let cdcniosh = Site(title: "CDC (NIOSH)", description: "The National Institute for Occupational Safety and Health (NIOSH)", url: "https://www.cdc.gov/niosh/index.htm") else {
            fatalError("Unable to create site")
        }
        
        guard let cdc = Site(title: "CDC", description: "Centers for Disease Control and Prevention", url: "https://www.cdc.gov") else {
            fatalError("Unable to create site")
        }
        
        guard let unmcCSCash = Site(title: "UNMC CS-CASH", description: "CENTRAL STATES CENTER FOR AGRICULTURAL SAFETY AND HEALTH", url: "https://www.unmc.edu/publichealth/cscash/") else {
            fatalError("Unable to create site")
        }
        
        guard let unmcAgriculture = Site(title: "UNMC Environmental, Agricultural & Occupational Health", description: "Environmental, Agricultural & Occupational Health", url: "https://www.unmc.edu/publichealth/cscash/") else {
            fatalError("Unable to create site")
        }
        
        guard let unmc = Site(title: "UNMC Health", description: "University of Nebraska Medical Center", url: "https://www.unmc.edu") else {
            fatalError("Unable to create site")
        }
        
        sites += [cdcniosh, cdc, unmcCSCash, unmcAgriculture, unmc]
    }

    /**
         Creates each of the cells of the table. Will use var sites.
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SafetyTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SafetyTableViewCell else {
            fatalError("The dequeued cell is not an instance of SafetyTableViewCell")
        }
        
        // Fetches the correct site
        let site = sites[indexPath.row]
        cell.titleLabel.text = site.title
        cell.descriptionLabel.text = site.description

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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let siteDetailViewController = segue.destination as? SiteWebViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let selectedSiteCell = sender as? SafetyTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedSiteCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        let selectedSite = sites[indexPath.row]
        siteDetailViewController.site = selectedSite
    }
 

}
