//
//  BusinessCell.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/6/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit
import AlamofireImage

class BusinessCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name

            addressLabel.text = business.address

            businessImageView.af_setImage(withURL: business.imageURL!, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: false)

            distanceLabel.text = business.distance

            var businessRating = "\(business.rating!)"
            if businessRating.contains(".") {
                businessRating = businessRating.components(separatedBy: ".")[0] + "_half"
            }
            ratingImageView.image = UIImage(named: "large_\(businessRating)")

            reviewsLabel.text = "\(business.reviewCount!) reviews"

            categoriesLabel.text = business.categories

            priceLabel.text = business.price
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        businessImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

