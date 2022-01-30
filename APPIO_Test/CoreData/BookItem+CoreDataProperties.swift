//
//  BookItem+CoreDataProperties.swift
//  APPIO_Test
//
//  Created by Константин Машейченко on 29.01.2022.
//
//

import Foundation
import CoreData


extension BookItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookItem> {
        return NSFetchRequest<BookItem>(entityName: "BookItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: Date?

}

extension BookItem : Identifiable {

}
