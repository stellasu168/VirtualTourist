//
//  Photos+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Stella Su on 2/20/16.
//  Copyright © 2016 Million Stars, LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photos {

    @NSManaged var url: String?
    @NSManaged var id: String?
    @NSManaged var filePath: String?
    @NSManaged var title: String?
    @NSManaged var pin: Pin?
    
}
