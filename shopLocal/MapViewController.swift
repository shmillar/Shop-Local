//
//  MapViewController.swift
//  shopLocal
//
//  Created by Sam Millar on 11/4/19.
//  Copyright © 2019 Sam Millar. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class MapViewController: UIViewController {
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var shopNameField: UILabel!
    @IBOutlet weak var weatherField: UILabel!
    
    var address:String?
    var name:String?
    var newsItems:NSDictionary?
    var wtype:String?
    var temperature:Double?
    var a:String?
    var zoom:Double = 0.0125
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addressString = address!
        CLGeocoder().geocodeAddressString(addressString, completionHandler:
            {(placemarks, error) in
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let span = MKCoordinateSpan.init(latitudeDelta: self.zoom, longitudeDelta: self.zoom)
                    let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                    let ani = MKPointAnnotation()
                    ani.coordinate = placemark.location!.coordinate
                    ani.title = self.name
                    self.map.addAnnotation(ani)
                }
        })
        getWeather()
        self.shopNameField.text = "Today's Weather at \(name!)"
        if self.weatherField.text == "Weather Field"{
            self.weatherField.text = "Unable to calculate Temperature."
        }
    }
    
    @IBAction func showMap(_ sender: Any) {
        switch(mapType.selectedSegmentIndex)
        {
        case 0:
            map.mapType = MKMapType.standard
        case 1:
            map.mapType = MKMapType.satellite
        default:
            map.mapType = MKMapType.standard
        }
    }
    
    func getWeather() {
        let delimiter = ", "
        var token = address!.components(separatedBy: delimiter)
        var city:String = ""
        if token.count != 1 && token.count != 0{
            city = token[1]
        }
        if token.count == 1{
            city = token[0]
        }
        let creplaced = (city as NSString).replacingOccurrences(of: " ", with: "+")
        let urlAsString = "http://api.openweathermap.org/data/2.5/weather?q=\(creplaced),us?&units=imperial&APPID=fa79da4eae3e29416d424ede49704b25"
        let url = URL(string: urlAsString)!
        let urlSession = URLSession.shared
        let jsonQuery = urlSession.dataTask(with: url, completionHandler: { data, response, error -> Void in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            var err: NSError?
            var jsonResult = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! Dictionary<String, AnyObject>
            if (err != nil) {
                print("JSON Error \(err!.localizedDescription)")
            }
            if jsonResult.count != 2{
                self.newsItems = jsonResult["main"] as? NSDictionary
                let x = jsonResult["weather"] as! NSMutableArray
                let y = x[0] as! NSDictionary
                self.wtype = y["main"] as? String
                self.temperature = self.newsItems!["temp"] as? Double
                DispatchQueue.main.async {
                    self.weatherField.text = "\(self.temperature!) °F - \(self.wtype!)"
                }
            }
        })
        jsonQuery.resume()
    }
    
    @IBAction func zoom(_ sender: UIStepper) {
        zoom = sender.value
        viewDidLoad()
    }
}
