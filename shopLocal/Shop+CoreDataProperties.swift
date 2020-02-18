//
//  Shop+CoreDataProperties.swift
//  shopLocal
//
//  Created by Sam Millar on 11/19/19.
//  Copyright © 2019 Sam Millar. All rights reserved.
//
//

import Foundation
import CoreData


extension Shop {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Shop> {
        return NSFetchRequest<Shop>(entityName: "Shop")
    }

    @NSManaged public var address: String?
    @NSManaged public var category: String?
    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var shop_description: String?
    @NSManaged public var i: Int32

}
