//
//  Business.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import Foundation

struct Business {

    let name: String?
    let address: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let rating: NSNumber?
    let reviewCount: NSNumber?
    let price: String?

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
            imageURL = URL(string: imageURLString!)
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
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }

        rating = dictionary["rating"] as? NSNumber ?? 0

        reviewCount = dictionary["review_count"] as? NSNumber ?? 0

        price = dictionary["price"] as? String
    }

    static func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }

    static func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }

    static func searchWithTerm(term: String, categories: [String]?, sort: YelpSortMode?, distance: Int?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) {
        _ = YelpClient.sharedInstance.searchWithTerm(term, categories: categories, sort: sort, distance: distance, deals: deals, completion: completion)
    }

}

