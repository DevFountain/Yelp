//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Curtis Wilcox on 4/7/17.
//  Copyright © 2017 DevFountain LLC. All rights reserved.
//

import UIKit

enum FilterSectionIdentifier: String {
    case offersDeal = ""
    case distance = "Distance"
    case sortBy = "Sort By"
    case category = "Category"
}

protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: Any])
}

class FiltersViewController: UITableViewController, FilterCellDelegate {

    var categoryFilters: [Filter]!
    var categoryToggles = [Int: Bool]()

    var sortModes: [Filter]!
    var sortToggles = [Int: Bool]()

    var distanceFilters: [Filter]!
    var distanceToggles = [Int: Bool]()

    var dealFilters: [Filter]!
    var dealToggles = [Int: Bool]()

    let tableStructure: [FilterSectionIdentifier] = [.offersDeal, .distance, .sortBy, .category]

    var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Filters"

        Filter.createCategoryFilters { (filters: [Filter]?, error: Error?) in
            self.categoryFilters = filters
        }

        Filter.createSortModes { (filters: [Filter]?, error: Error?) in
            self.sortModes = filters
        }

        Filter.createDistanceFilters { (filters: [Filter]?, error: Error?) in
            self.distanceFilters = filters
        }

        Filter.createDealFilters { (filters: [Filter]?, error: Error?) in
            self.dealFilters = filters
        }

        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableStructure.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableStructure[section].rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dealFilters.count
        case 1:
            return distanceFilters.count
        case 2:
            return sortModes.count
        case 3:
            return categoryFilters.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell

        // Configure the cell...

        cell.delegate = self

        switch indexPath.section {
        case 0:
            cell.filter = dealFilters[indexPath.row]
            cell.toggle.isOn = dealToggles[indexPath.row] ?? false
        case 1:
            cell.filter = distanceFilters[indexPath.row]
            cell.toggle.isOn = distanceToggles[indexPath.row] ?? false
        case 2:
            cell.filter = sortModes[indexPath.row]
            cell.toggle.isOn = sortToggles[indexPath.row] ?? false
        case 3:
            cell.filter = categoryFilters[indexPath.row]
            cell.toggle.isOn = categoryToggles[indexPath.row] ?? false
        default:
            break
        }

        return cell
    }

    func filterCell(filterCell: FilterCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: filterCell)!

        switch indexPath.section {
        case 0:
            dealToggles[indexPath.row] = value
        case 1:
            distanceToggles[indexPath.row] = value
        case 2:
            sortToggles[indexPath.row] = value
        case 3:
            categoryToggles[indexPath.row] = value
        default:
            break
        }
    }

    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func didTapSearch(_ sender: Any) {
        dismiss(animated: true)

        var filters = [String: Any]()

        var selectedCategories = [String]()
        var selectedSortMode: YelpSortMode?
        var selectedDistance: NSNumber?
        var selectedDeal: Bool?

        for (row, isOn) in categoryToggles {
            if isOn {
                selectedCategories.append(categoryFilters[row].value as! String)
            }
        }

        for (row, isOn) in sortToggles {
            if isOn {
                selectedSortMode = YelpSortMode(rawValue: sortModes[row].value as! String)!
            }
        }

        for (row, isOn) in distanceToggles {
            if isOn {
                selectedDistance = distanceFilters[row].value as? NSNumber
            }
        }

        for (row, isOn) in dealToggles {
            if isOn {
                selectedDeal = dealFilters[row].value as? Bool
            }
        }

        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }

        filters["sortMode"] = selectedSortMode ?? nil

        filters["distance"] = selectedDistance ?? nil

        filters["deals"] = selectedDeal ?? nil

        delegate?.filtersViewController(filtersViewController: self, didUpdateFilters: filters)

    }

}

