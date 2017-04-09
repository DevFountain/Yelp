//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/7/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit
import MBProgressHUD

class BusinessViewController: UITableViewController, UISearchResultsUpdating, FiltersViewControllerDelegate {

    var businesses: [Business]!

    var filteredBusinesses: [Business]!

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        MBProgressHUD.showAdded(to: self.view, animated: true)

        Business.searchWithTerm(term: "Restaurants") { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.placeholder = "Restaurants"
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.contentOffset = CGPoint(x: 0.0, y: -64.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBusinesses.count
        } else {
            if businesses != nil {
                return businesses.count
            } else {
                return 0
            }
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        if searchController.isActive && searchController.searchBar.text != "" {
            cell.business = filteredBusinesses[indexPath.row]
        } else {
            cell.business = businesses[indexPath.row]
        }

        return cell
    }

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredBusinesses = searchText.isEmpty ? businesses : businesses.filter({ (business) -> Bool in
                if let name = business.name {
                    return name.range(of: searchText, options: .caseInsensitive) != nil
                }
                return false
            })
            tableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : Any]) {
        let categories = filters["categories"] as? [String]
        let sort = filters["sortMode"] as? YelpSortMode
        let distance = filters["distance"] as? NSNumber
        let deals = filters["deals"] as? Bool

        MBProgressHUD.showAdded(to: self.view, animated: true)

        Business.searchWithTerm(term: "Restaurants", categories: categories, sort: sort, distance: distance as? Int, deals: deals) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

}

