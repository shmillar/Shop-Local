//
//  ViewController.swift
//  shopLocal
//
//  Created by Sam Millar on 11/3/19.
//  Copyright © 2019 Sam Millar. All rights reserved.
//

import UIKit
import CoreData
import Photos

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shopTable: UITableView!
    
    var counter = 1
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fetchResults = [Shop]()
    var addedName:String?
    var addedCategory:String?
    var addedAddress:String?
    var addedDescription:String?
    var addedImage:NSData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCounter()
        shopTable.reloadData()
    }
    
    func fetchRecord() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shop")
        let sort = NSSortDescriptor(key: "i", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        var x = 0
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [Shop])!
        x = fetchResults.count
        return x
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchRecord()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopCell", for: indexPath)
        cell.layer.borderWidth = 1.5
        cell.layer.borderColor = UIColor.darkGray.cgColor
        cell.textLabel?.text = fetchResults[indexPath.row].name
        cell.detailTextLabel?.text = fetchResults[indexPath.row].shop_description
        if let picture = fetchResults[indexPath.row].image
        {
            cell.imageView?.image =  UIImage(data: picture  as Data)
        }
        else
        {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell.EditingStyle { return UITableViewCell.EditingStyle.delete }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            managedObjectContext.delete(fetchResults[indexPath.row])
            fetchResults.remove(at:indexPath.row)
            do {
                try managedObjectContext.save()
            }
            catch {}
            shopTable.reloadData()
        }
    }
    
    func updateLastRow() {
        let indexPath = IndexPath(row: fetchResults.count - 1, section: 0)
        shopTable.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    func initCounter() {
        counter = UserDefaults.init().integer(forKey: "counter")
    }
    
    func updateCounter() {
        counter += 1
        UserDefaults.init().set(counter, forKey: "counter")
        UserDefaults.init().synchronize()
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        picker .dismiss(animated: true, completion: nil)
        if let shop = fetchResults.last, let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            shop.image = image.pngData()! as NSData
            self.shopTable.reloadData()
            do {
                try managedObjectContext.save()
            } catch {
                print("Error while saving the new image")
            }
        }
    }
    
    @IBAction func unwindToViewController(segue:UIStoryboardSegue) {
        let ent = NSEntityDescription.entity(forEntityName: "Shop", in: self.managedObjectContext)
        let newItem = Shop(entity: ent!, insertInto: self.managedObjectContext)
        newItem.name = addedName
        newItem.category = addedCategory
        newItem.address = addedAddress
        newItem.shop_description = addedDescription
        newItem.image = addedImage
        newItem.i = Int32(counter)
        updateCounter()
        do {
            try self.managedObjectContext.save()
        } catch _ {}
        shopTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "detailView"){
            let selectedIndex: IndexPath = self.shopTable.indexPath(for: sender as! UITableViewCell)!
            if let viewController: DetailViewController = segue.destination as? DetailViewController {
                viewController.selectedName = fetchResults[selectedIndex.row].name
                viewController.selectedCategory = fetchResults[selectedIndex.row].category
                viewController.selectedAddress = fetchResults[selectedIndex.row].address
                viewController.selectedDescription = fetchResults[selectedIndex.row].shop_description
                viewController.selectedImage = fetchResults[selectedIndex.row].image
            }
        }
    }
}

