//
//  ElementDetailViewController.swift
//  AC3.2-MidtermElements
//
//  Created by Tom Seymour on 12/8/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class ElementDetailViewController: UIViewController {
    
    let favoritesPostEndpoint = "https://api.fieldbook.com/v1/58488d40b3e2ba03002df662/favorites"
    var element: Element!
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var boilingPointLabel: UILabel!
    @IBOutlet weak var meltingpointLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadElementDetailVC()
        
    }
    
    func loadElementDetailVC() {
        activityIndicator.startAnimating()
        navigationItem.title = self.element.name
        nameLabel.text = self.element.name
        weightLabel.text = String(self.element.weight)
        if let bp = element.boilingPoint {
            boilingPointLabel.text = "Boiling Point: \(String(bp))∘C"
        } else {
            boilingPointLabel.text = "No Boiling Point"
        }
        if let mp = element.meltingPoint {
            meltingpointLabel.text = "Melting Point: \(String(mp))∘C"
        } else {
            meltingpointLabel.text = "No Melting Point"
        }
        numberLabel.text = String(element.number)
        APIRequestManager.manager.getData(endPoint: element.fullImageUrlString) { (data) in
            if let imageData = data {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.fullImageView.image = UIImage(data: imageData)
                }
            }
        }
    }

    func showAlertWith(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func didPressFavorite(_ sender: UIBarButtonItem) {
        favoriteButton.isEnabled = false
        self.activityIndicator.bringSubview(toFront: fullImageView)
        activityIndicator.startAnimating()
        print("<3")
        let postDict = ["my_name": "Tom Seymour", "favorite_element": element.symbol]
        APIRequestManager.manager.postRequest(endPoint: favoritesPostEndpoint, data: postDict) { (response) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let response = response {
                    switch response.statusCode {
                    case 200..<299:
                        self.showAlertWith(title: "😀", message: "Successfully Saved \(self.element.name) to Favorites")
                    default:
                        self.showAlertWith(title: "😬", message: "Something Went Wrong, Couldn't Save \(self.element.name) to Favorites")
                    }
                }
            }
        }
    }
}
