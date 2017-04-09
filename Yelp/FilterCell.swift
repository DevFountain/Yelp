//
//  FilterCell.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/8/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit

protocol FilterCellDelegate {
    func filterCell(filterCell: FilterCell, didChangeValue value: Bool)
}

class FilterCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!

    var delegate: FilterCellDelegate?

    var filter: Filter! {
        didSet {
            filterLabel.text = filter.name
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func toggled(_ sender: Any) {
        delegate?.filterCell(filterCell: self, didChangeValue: toggle.isOn)
    }

}

