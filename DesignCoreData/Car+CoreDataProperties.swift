//
//  Car+CoreDataProperties.swift
//  DesignCoreData
//
//  Created by yangfourone on 2018/10/10.
//  Copyright © 2018 41. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var plate: String?
    @NSManaged public var belongto: UserData?

}
