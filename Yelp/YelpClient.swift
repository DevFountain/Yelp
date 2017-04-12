//
//  YelpClient.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import Foundation
import Alamofire

enum YelpSortMode: String {
    case best_match, rating, review_count, distance
}

class YelpClient {

    static let sharedInstance = YelpClient()

    // TODO: configure app to run once if access token not set
    func getAccessToken() {
        let oauthUrl = "https://api.yelp.com/oauth2/token"

        let parameters: Parameters = [
            "grant_type": "client_credentials",
            "client_id": clientId,
            "client_secret": clientSecret
        ]

        Alamofire.request(oauthUrl, method: .post, parameters: parameters).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.result.value {
                    // TODO: configure app to request and store access token
                    print("JSON: \(json)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        return searchWithTerm(term, categories: nil, sort: nil, distance: nil, deals: nil, completion: completion)
    }

    func searchWithTerm(_ term: String, categories: [String]?, sort: YelpSortMode?, distance: Int?, deals: Bool?, completion: @escaping ([Business]?, Error?) -> Void) {
        let baseUrl = "https://api.yelp.com/v3/businesses/search"

        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "Accept": "application/json"
        ]

        var parameters: Parameters = [
            "term": term,
            // Set location to San Francisco, CA
            "latitude": 37.7577627,
            "longitude": -122.4726193
        ]

        if categories != nil && categories!.count > 0 {
            parameters["categories"] = categories!.joined(separator: ",")
        }

        if sort != nil {
            parameters["sort_by"] = sort!.rawValue
        }

        if distance != nil {
            parameters["radius"] = distance!
        }

        if deals != nil {
            if deals! {
                parameters["attributes"] = "deals"
            }
        }

        print(parameters)

        Alamofire.request(baseUrl, parameters: parameters, headers: headers).validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let json = response.result.value as? NSDictionary {
                    let dictionaries = json["businesses"] as? [NSDictionary]
                    if dictionaries != nil {
                        completion(Business.businesses(array: dictionaries!), nil)
                    }
                }
            case .failure(let error):
                completion(nil, error)
                print(error)
            }
        }
    }

}

