//
//  Product+CoreDataProperties.swift
//  Lab_Assignment_A2
//
//  Created by Janakiram Gupta on 19/09/21.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var productdescription: String?
    @NSManaged public var productid: Int64
    @NSManaged public var productname: String?
    @NSManaged public var productprice: String?
    @NSManaged public var productprovider: String?

}

extension Product : Identifiable {

}
