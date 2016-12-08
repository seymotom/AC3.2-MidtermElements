//
//  ElementsTableViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Tom Seymour on 12/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class ElementsTableViewController: UITableViewController {
    
    var elements: [Element] = []
    
    let elementsCellIdentifier = "elementCell"
    let elementDetailSegueIdentifier = "elementDetailSegueIdentifier"
    let elementsApiEndpoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/elements"

    override func viewDidLoad() {
        super.viewDidLoad()
        loadElementsTable()
    }
    
    func loadElementsTable() {
        navigationItem.title = "Elements"
        APIRequestManager.manager.getData(endPoint: elementsApiEndpoint) { (data) in
            if let data = data {
                DispatchQueue.main.async {
                    self.elements = Element.buildElementArr(from: data)!
                    self.tableView.reloadData()
                }
            }
        }
    }

   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: elementsCellIdentifier, for: indexPath)
        let thisElement = elements[indexPath.row]
        cell.textLabel?.text = "\(thisElement.number).  \(thisElement.name)"
        cell.detailTextLabel?.text = "\(thisElement.symbol) (\(thisElement.number)) \(thisElement.weight)"
        cell.imageView?.image = #imageLiteral(resourceName: "loading")
        
        APIRequestManager.manager.getData(endPoint: thisElement.thumbnailUrlString) { (data) in
            if let imageData = data {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: imageData)
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == elementDetailSegueIdentifier {
            guard let dvc = segue.destination as? ElementDetailViewController,
                let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else { return }
            dvc.element = elements[indexPath.row]
        }
    }
    

}
