//
//  AddShopViewController.swift
//  shopLocal
//
//  Created by Sam Millar on 11/4/19.
//  Copyright © 2019 Sam Millar. All rights reserved.
//

import Foundation
import UIKit
class AddShopViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var categorySegmentedController: UISegmentedControl!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var photoType: UISegmentedControl!
    @IBOutlet weak var imageField: UIImageView!
    
    let picker = UIImagePickerController()
    var newPic = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addImage(_ sender: Any) {
        if photoType.selectedSegmentIndex == 0
        {
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.picker.allowsEditing = false
                self.picker.sourceType = .camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker, animated: true, completion: nil)
            }else{
                print("No Camera")
            }
        }
        else if photoType.selectedSegmentIndex == 1
        {
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.picker.modalPresentationStyle = .popover
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        self.newPic = ((info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage?)!)
        self.imageField.image = newPic
        
        dismiss(animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let viewController: ViewController = (segue.destination as? ViewController)!
        viewController.addedName = self.nameField.text
        switch self.categorySegmentedController.selectedSegmentIndex{
            case 0:
                viewController.addedCategory = "Food"
            case 1:
                viewController.addedCategory = "Personal"
            case 2:
                viewController.addedCategory = "Clothing"
            case 3:
                viewController.addedCategory = "Other"
            default:
                viewController.addedCategory = "Other"
        }
        viewController.addedAddress = self.addressField.text
        viewController.addedDescription = self.descriptionField.text
        viewController.addedImage = newPic.pngData() as NSData?
        if newPic.pngData() != nil{
            viewController.addedImage = newPic.pngData() as NSData?
        }
        else{
            viewController.addedImage = UIImage(named: "shopLocalLogo")?.pngData() as NSData?
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

