//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit
import AlamofireImage

class BusinessViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var businesses: [Business]!

    @IBOutlet weak var tableView: UITableView!
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        } else {
            return 0
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

        let business = self.businesses[indexPath.row]

        cell.businessImageView.image = nil
        if let imageUrl = business.imageURL {
            cell.businessImageView.af_setImage(withURL: imageUrl)
        }

        cell.nameLabel.text = business.name

        cell.distanceLabel.text = business.distance

        var businessRating = "\(business.rating ?? 0)"
        if businessRating.contains(".") {
            businessRating = businessRating.components(separatedBy: ".")[0] + "_half"
        }
        cell.ratingImageView.image = UIImage(named: "large_\(businessRating)")

        cell.reviewsLabel.text = "\(business.reviewCount ?? 0) Reviews"

        cell.addressLabel.text = business.address

        cell.categoriesLabel.text = business.categories

        return cell
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

