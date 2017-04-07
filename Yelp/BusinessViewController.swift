//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit
import AlamofireImage

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!

    var businesses: [Business]!

    var filteredBusinesses: [Business]!

    var searchController: UISearchController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        Business.searchWithTerm(term: "Thai") { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            self.tableView.reloadData()
        }

//        Business.searchWithTerm(term: "Restaurants", categories: ["asianfusion", "burgers"], sort: .distance, deals: true) { (businesses: [Business]?, error: Error?) in
//            self.businesses = businesses
//            self.tableView.reloadData()
//        }

        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self

        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.placeholder = "Restaurants"
        searchController.searchBar.sizeToFit()
        navigationItem.titleView = searchController.searchBar

        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredBusinesses.count
        } else {
            if let businesses = businesses {
                return businesses.count
            } else {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YelpCell", for: indexPath) as! YelpCell

        var business: Business!

        if searchController.isActive && searchController.searchBar.text != "" {
            business = filteredBusinesses[indexPath.row]
        } else {
            business = businesses[indexPath.row]
        }

        cell.businessImageView.image = nil
        if let imageUrl = business.imageURL {
            cell.businessImageView.af_setImage(withURL: imageUrl, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)
        }
        cell.businessImageView.layer.cornerRadius = cell.businessImageView.frame.height / 20

        cell.nameLabel.text = business.name

        cell.distanceLabel.text = business.distance

        var businessRating = "\(business.rating ?? 0)"
        if businessRating.contains(".") {
            businessRating = businessRating.components(separatedBy: ".")[0] + "_half"
        }
        cell.ratingImageView.image = UIImage(named: "large_\(businessRating)")

        cell.reviewsLabel.text = "\(business.reviewCount ?? 0) reviews"

        cell.addressLabel.text = business.address

        cell.categoriesLabel.text = business.categories

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

