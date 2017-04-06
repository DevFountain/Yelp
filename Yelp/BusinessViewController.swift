//
//  BusinessViewController.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit

class BusinessViewController: UIViewController {

    var businesses: [Business]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        Business.searchWithTerm(term: "Thai") { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }

        Business.searchWithTerm(term: "Restaurants", categories: ["asianfusion", "burgers"], sort: .distance, deals: true) { (businesses: [Business]?, error: Error?) in
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
