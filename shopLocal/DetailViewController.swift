//
//  DetailViewController.swift
//  shopLocal
//
//  Created by Sam Millar on 11/4/19.
//  Copyright © 2019 Sam Millar. All rights reserved.
//

import Foundation
import UIKit
class DetailViewController: UIViewController {
    
    var selectedName:String?
    var selectedCategory:String?
    var selectedAddress:String?
    var selectedDescription:String?
    var selectedImage:NSData?
    
    @IBOutlet weak var imageField: UIImageView!
    @IBOutlet weak var nameField: UILabel!
    @IBOutlet weak var categoryField: UILabel!
    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var descriptionField: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedImage != nil{
            self.imageField.image = UIImage(data: selectedImage! as Data)
        }
        self.nameField.text = selectedName
        self.categoryField.text = selectedCategory
        self.addressField.text = selectedAddress
        self.descriptionField.text = selectedDescription
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapView"){
            if let viewController: MapViewController = segue.destination as? MapViewController {
                viewController.address = selectedAddress
                viewController.name = selectedName
            }
        }
    }
}
