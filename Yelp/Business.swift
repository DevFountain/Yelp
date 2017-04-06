//
//  Business.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit

class Business: NSObject {

    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let rating: NSNumber?
    let reviewCount: NSNumber?

    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String

        let location = dictionary["location"] as? NSDictionary
        var address = ""
        if location != nil {
            address = location!["address1"] as! String
        }
        self.address = address

        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }

        let categoriesDictionary = dictionary["categories"] as? [NSDictionary]
        var categoryNames = [String]()
        if categoriesDictionary != nil {
            for category in categoriesDictionary! {
                let categoryName = category["title"] as? String
                categoryNames.append(categoryName!)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }

        let distanceMeters = dictionary["distance"] as? NSNumber
        if distanceMeters != nil {
            let distanceMeters = Measurement(value: distanceMeters!.doubleValue, unit: UnitLength.meters)
            distance = String(format: "%.2f mi", distanceMeters.converted(to: UnitLength.miles) as CVarArg)
        } else {
            distance = nil
        }

        rating = dictionary["rating"] as? NSNumber

        reviewCount = dictionary["review_count"] as? NSNumber
    }

    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }

    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }

    class func searchWithTerm(term: String, categories: [String]?, sort: YelpSortMode?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, categories: categories, sort: sort, deals: deals, completion: completion)
    }

}

