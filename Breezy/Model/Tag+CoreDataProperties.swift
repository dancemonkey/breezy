//
//  Tag+CoreDataProperties.swift
//  Breezy
//
//  Created by Drew Lanning on 2/4/18.
//  Copyright © 2018 Drew Lanning. All rights reserved.
//
//

import Foundation
import CoreData


extension Tag {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
    return NSFetchRequest<Tag>(entityName: "Tag")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var creation: NSDate?
  @NSManaged public var documents: NSSet?
  
}

// MARK: Generated accessors for documents
extension Tag {
  
  @objc(addDocumentsObject:)
  @NSManaged public func addToDocuments(_ value: Document)
  
  @objc(removeDocumentsObject:)
  @NSManaged public func removeFromDocuments(_ value: Document)
  
  @objc(addDocuments:)
  @NSManaged public func addToDocuments(_ values: NSSet)
  
  @objc(removeDocuments:)
  @NSManaged public func removeFromDocuments(_ values: NSSet)
  
}
